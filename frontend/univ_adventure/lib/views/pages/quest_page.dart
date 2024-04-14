import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/quests.dart';
import '../../components/quest_card.dart';
import 'quest_detail_page.dart';
import '../../services/user_manager.dart';

class QuestPage extends StatelessWidget {
  
Future<List<Quest>> loadQuests() async {
  final ref = FirebaseStorage.instance.ref().child('quests.json');
  final data = await ref.getData();
  final jsonStr = utf8.decode(data!);
  final List<dynamic> json = jsonDecode(jsonStr);
  return json.map((e) => Quest.fromJson(e)).toList();
}

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
              return Center(
                  child: Text(
                      "Erreur lors du chargement des quêtes : ${snapshot.error}"));
            }
            return ListView(
              children: snapshot.data!
                  .map((quest) => QuestCard(
                        quest: quest,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuestDetailPage(
                                quest: quest, user: UserManager.getUser()!),
                          ),
                        ),
                        isCompleted: UserManager.getUser()!
                            .questsCompleted
                            .contains(quest.questId),
                      ))
                  .toList()
                  .cast<Widget>(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}