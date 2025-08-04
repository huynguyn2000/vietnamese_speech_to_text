// lib/screens/recording_page.dart
import 'package:flutter/material.dart';

import 'dart:io';

import '../widgets/record_button.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool isRecording = false;
  String transcribedText = '';

  final AudioRecorder _recorder = AudioRecorder();
  String? _audioPath;

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      Directory tempDir = await getTemporaryDirectory();
      _audioPath = '${tempDir.path}/recorded_audio.m4a';
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _audioPath!,
      );
      print('Recording started: $_audioPath');
    } else {
      print('No microphone permission');
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    print('Recording stopped. File saved at: $path');
    _audioPath = path;
  }

  Future<String> _uploadAudioToSupabase() async {
    final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav'; // Match the recording format
    final file = File(_audioPath!);

    await Supabase.instance.client.storage
        .from('audio-files')
        .upload(fileName, file);

    final audioUrl = Supabase.instance.client.storage
        .from('audio-files')
        .getPublicUrl(fileName);

    print('Audio uploaded. URL: $audioUrl');
    return audioUrl;
  }

  Future<void> saveTranscriptionToHistory(String text, String audioUrl) async {
    // Upload audio file to Supabase Storage
    // final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
    // final file = File(audioPath);
    //
    // await Supabase.instance.client.storage
    //     .from('audio-files') // Create this bucket in Supabase
    //     .upload(fileName, file);
    //
    // // Get the public URL
    // final audioUrl = Supabase.instance.client.storage
    //     .from('audio-files')
    //     .getPublicUrl(fileName);
    //
    // print('Audio URL: $audioUrl');

    // Save transcription with audio URL
    await Supabase.instance.client
        .from('transcription_history')
        .insert({
          'text': text,
          'audio_url': audioUrl,
          'created_at': DateTime.now().toIso8601String(),
        });
  }

  Future<void> transcribe() async {
    if (_audioPath == null) return;

    // Upload audio first
    final audioUrl = await _uploadAudioToSupabase();

    try {
      var uri = Uri.parse('http://localhost:8000/transcribe');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('audio_file', _audioPath!));

      var response = await request.send();

      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        var jsonResp = jsonDecode(respStr);

        // Check if the API response indicates success
        if (jsonResp['success'] == true) {
          setState(() {
            transcribedText = jsonResp['text'] ?? 'No text found';
          });
          // Save to history with the uploaded audio URL
          await saveTranscriptionToHistory(jsonResp['text'] ?? 'No text found', audioUrl);
        } else {
          setState(() {
            transcribedText = 'Transcription failed: ${jsonResp['detail'] ?? 'Unknown error'}';
          });
        }
      } else {
        // Handle HTTP error
        var respStr = await response.stream.bytesToString();
        var errorResp = jsonDecode(respStr);
        setState(() {
          transcribedText = 'Transcription failed: ${errorResp['detail'] ?? 'HTTP ${response.statusCode}'}';
        });
      }
    } catch (e) {
      setState(() {
        transcribedText = 'Transcription failed: $e';
      });
      print('Transcription error: $e');
    }
  }

  void _onRecordButtonTap() async {
    if (!isRecording) {
      setState(() => isRecording = true);
      await _startRecording();
    } else {
      setState(() => isRecording = false);
      await _stopRecording();
      await transcribe();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Transcription Display Area
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SingleChildScrollView(
                child: Text(
                  transcribedText.isEmpty ?
                    'Your transcribed text will appear here...' :
                    transcribedText,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: transcribedText.isEmpty
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.grey[800])
                        : null,
                  ),
                ),
              ),
            ),
          ),

          // Clear Button
          if (transcribedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    transcribedText = '';
                  });
                },
                icon: Icon(Icons.clear),
                label: Text('Clear Text'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          // Recording Button
          SizedBox(height: 20),
          RecordButton(
            isRecording: isRecording,
            onTap: _onRecordButtonTap,
          ),
        ],
      ),
    );
  }
}