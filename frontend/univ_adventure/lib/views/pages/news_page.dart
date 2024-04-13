// lib/views/pages/news_page.dart
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: Center(
        child: Text('Welcome to News Page!'),
      ),
    );
  }
}
