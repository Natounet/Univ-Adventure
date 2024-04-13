import 'package:flutter/material.dart';
import '../models/quests.dart'; // Assurez-vous que le chemin d'accès au modèle est correct
import '../services/user_manager.dart'; // Assurez-vous que le chemin d'accès au service est correct
import '../models/user.dart'; // Assurez-vous que le chemin d'accès au modèle est correct

class QuestCard extends StatefulWidget {
  final Quest quest;
  final VoidCallback onTap;
  final bool isCompleted;

  QuestCard({required this.quest, required this.onTap, required this.isCompleted});

  @override
  _QuestCardState createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Stream.value(UserManager.getUser()!), // Remplacez par votre flux d'utilisateur
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data!;
          bool isCompleted = user.questsCompleted.contains(widget.quest.questId);

          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(8.0),
            color: isCompleted ? Colors.grey : null,
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.quest.title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(widget.quest.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 24.0),
                  ],
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator(); // Affiche un indicateur de progression pendant le chargement des données
        }
      },
    );
  }
}