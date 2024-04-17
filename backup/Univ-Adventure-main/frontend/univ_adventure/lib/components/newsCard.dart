import 'package:flutter/material.dart';
import '../models/news.dart'; // Assurez-vous que le chemin d'accès au modèle est correct

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Color.fromRGBO(182, 196, 182, 1),
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: news.image.isPresent ? 300 : 100.0,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(news.title,
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(news.description,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14.0)),
                      ]),
                  if (news.image.isNotEmpty)
                    Container(
                      child: Image.network(news.image.value,
                          height: 200, width: 200),
                    ),
                ]),
              ),
              const Icon(Icons.arrow_forward, size: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
