import 'package:flutter/material.dart';
import '../../models/news.dart';

import 'package:permission_handler/permission_handler.dart';

void requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    status = await Permission.camera.request();
    if (!status.isGranted) {
      // Handle the case where the user did not grant the permission
    }
  }
}

class NewsDetailPage extends StatelessWidget {
  final News news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news.title,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(news.article, style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
