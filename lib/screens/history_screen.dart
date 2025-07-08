// lib/screens/history_screen.dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> sampleHistory = [
    {
      'text': 'Sample transcription 1',
      'date': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'text': 'Sample transcription 2',
      'date': DateTime.now().subtract(Duration(days: 2)),
    },
    // Add more sample items
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: sampleHistory.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: ListTile(
              title: Text(sampleHistory[index]['text']),
              subtitle: Text(
                sampleHistory[index]['date'].toString(),
                style: TextStyle(fontSize: 12.0),
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Show options menu
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.copy),
                              title: Text('Copy'),
                              onTap: () {
                                // Handle copy
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.share),
                              title: Text('Share'),
                              onTap: () {
                                // Handle share
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                              onTap: () {
                                // Handle delete
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}