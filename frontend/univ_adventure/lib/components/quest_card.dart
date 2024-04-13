import 'package:flutter/material.dart';
import '../models/quests.dart'; // Assurez-vous que le chemin d'accès au modèle est correct

class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback onTap;
  final bool isCompleted;

  QuestCard({required this.quest, required this.onTap, this.isCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      color: isCompleted ? Colors.grey : null,
      child: InkWell(
        onTap: onTap,
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
                    Text(quest.title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(quest.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.0)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, size: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}