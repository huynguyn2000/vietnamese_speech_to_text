// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Vietnamese'),
            onTap: () {
              // Handle language selection
            },
          ),
          ListTile(
            leading: Icon(Icons.mic),
            title: Text('Speech Recognition'),
            subtitle: Text('Settings'),
            onTap: () {
              // Handle speech recognition settings
            },
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Auto Save'),
            trailing: Switch(
              value: true,  // You should manage this state
              onChanged: (bool value) {
                // Handle auto save toggle
              },
            ),
          ),
        ],
      ),
    );
  }
}