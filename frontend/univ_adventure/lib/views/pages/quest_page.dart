import 'package:flutter/material.dart';
import '../../models/quests.dart'; // Importez votre fichier de modèle Quest ici

class QuestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quest>>(
      future: loadQuests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListView(
            children: snapshot.data!.map((quest) => ListTile(
              title: Text(quest.title),
              subtitle: Text(quest.description),
            )).toList(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
