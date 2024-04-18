import 'package:flutter/material.dart';
import '../models/quest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestCard extends StatefulWidget {
  final Quest quest;
  final VoidCallback onTap;
  final bool isCompleted;

  const QuestCard(
      {Key? key,
      required this.quest,
      required this.onTap,
      required this.isCompleted})
      : super(key: key);

  @override
  QuestCardState createState() => QuestCardState();
}

class QuestCardState extends State<QuestCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc('userId')
          .snapshots(), // Replace 'userId' with actual user id
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data!.data() as Map<String, dynamic>;
          bool isCompleted =
              user['questsCompleted'].contains(widget.quest.questId);

          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            color: isCompleted ? Colors.grey : null,
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.quest.title,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(widget.quest.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, size: 24.0),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
