// lib/screens/recording_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/record_button.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool isRecording = false;
  String transcribedText = '';

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
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),

          // Recording Button
          SizedBox(height: 20),
          RecordButton(
            isRecording: isRecording,
            onTap: () {
              setState(() {
                isRecording = !isRecording;
                // Add recording logic here
              });
            },
          ),
        ],
      ),
    );
  }
}