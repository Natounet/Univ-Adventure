import 'package:flutter/material.dart';
import '../../models/quests.dart'; // Importez votre fichier de modèle Quest ici
import '../../components/quest_card.dart';
import 'quest_detail_page.dart';
import '../../services/user_manager.dart'; // Assurez-vous d'importer la classe UserManager correctement

class QuestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quêtes disponibles"),
      ),
      body: FutureBuilder<List<Quest>>(
        future: loadQuests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Erreur lors du chargement des quêtes : ${snapshot.error}"));
            }
            return ListView(
              children: snapshot.data!.map((quest) => QuestCard(
                quest: quest,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestDetailPage(quest: quest, user: UserManager.getUser()!),
                  ),
                ),
                isCompleted: UserManager.getUser()!.questsCompleted.contains(quest.questId),
              )).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}