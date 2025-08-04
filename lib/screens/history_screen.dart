// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as ap;

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final List result = await Supabase.instance.client
      .from('transcription_history')
      .select()
      .order('created_at', ascending: false);

    List<String> transcriptions = result.map((row) => row['text'] as String).toList();
    setState(() {
      this.history = List<Map<String, dynamic>>.from(result);
    });
  }

  void showHistoryDetail(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        final ap.AudioPlayer _player = ap.AudioPlayer();
        return AlertDialog(
          title: Text('Transcription Detail'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['text'] ?? '', style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),
              Text('Date: ${item['date']}', style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.play_arrow),
                label: Text('Play Audio'),
                // In history_screen.dart, update the playback button:
                onPressed: () async {
                  await _player.play(ap.UrlSource(item['audio_url']));
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _player.stop();
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: history.isEmpty
          ? Center(child: Text('No history yet.'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    title: Text(item['text'] ?? ''),
                    subtitle: Text(item['date'] ?? '', style: TextStyle(fontSize: 12.0)),
                    onTap: () => showHistoryDetail(item),
                  ),
                );
              },
            ),
    );
  }
}