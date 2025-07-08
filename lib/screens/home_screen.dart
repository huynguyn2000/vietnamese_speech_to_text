// lib/screens/home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vietnamese_speech_to_text/screens/recording_page.dart';
import 'package:vietnamese_speech_to_text/screens/settings_screen.dart';

import 'history_screen.dart';

class HomeScreen extends StatefulWidget {  // Change to StatefulWidget
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;  // Track selected tab

  // Add this method to handle tab changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of pages to show
  final List<Widget> _pages = [
    RecordingPage(),
    HistoryScreen(),
    SettingsScreen(),  // Create this screen if you haven't
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text'),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],  // Show selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}