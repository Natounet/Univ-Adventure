// lib/views/pages/quest_page.dart
import 'package:flutter/material.dart';

class QuestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quests'),
      ),
      body: Center(
        child: Text('Welcome to Quests Page!'),
      ),
    );
  }
}
