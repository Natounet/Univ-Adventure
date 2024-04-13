// lib/views/pages/news_page.dart
import 'package:flutter/material.dart';
import 'package:univ_adventure/models/news.dart';
import '../../components/newsCard.dart';
import 'news_detail_page.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: Center(
        child: FutureBuilder<List<News>>(
          future: loadNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                        "Erreur lors du chargement des news : ${snapshot.error}"));
              }
              return ListView(
                children: snapshot.data!
                    .map((news) => NewsCard(
                          news: news,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NewsDetailPage(news: news),
                            ),
                          ),
                        ))
                    .toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
