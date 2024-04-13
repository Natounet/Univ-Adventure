import 'package:flutter/material.dart';
import 'package:univ_adventure/models/news.dart';
import '../../components/newsCard.dart';
import 'news_detail_page.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({superKey, Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('News'),
            backgroundColor: Color.fromRGBO(182, 210, 182, 1)),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(182, 210, 182, 1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dernières actualités',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: FutureBuilder<List<News>>(
                    future: loadNews(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Erreur lors du chargement des news : ${snapshot.error}",
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final news = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: NewsCard(
                                news: news,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewsDetailPage(news: news),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
