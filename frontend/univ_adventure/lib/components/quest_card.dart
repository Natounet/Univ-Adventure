import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:univ_adventure/components/badge.dart';
import 'package:univ_adventure/components/xp.dart';
import 'package:univ_adventure/models/quest.dart';
import '../models/quest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;

  QuestCard({required this.quest, Key? key}) : super(key: key);

  // Définissez votre variable de couleur ici
  final Color iconColor = const Color.fromARGB(244, 244, 207, 154);
  const QuestCard(
      {Key? key,
      required this.quest,
      required this.onTap,
      required this.isCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            iconColor, // Utilisez la variable de couleur ici
                        child: new Icon(quest.icon, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
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
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  quest.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                XPComponent(
                                  xp: quest.xp,
                                  scale: 0.7,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                BadgeComponent(
                                  badgeName: "Exploration",
                                  badgeIcon: Icons.terminal,
                                  circleColor:
                                      iconColor, // Utilisez la variable de couleur ici
                                  scale: 0.75,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Validé par 132 personnes',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
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
                  ),
                  IconButton(
                    onPressed: () {
                      // Ajoutez votre logique onPressed du bouton ici
                    },
                    icon: CircleAvatar(
                      radius: 17,
                      backgroundColor:
                          iconColor, // Utilisez la variable de couleur ici
                      child: const Icon(
                        LucideIcons.x,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    padding: const EdgeInsets.all(0),
                    constraints: const BoxConstraints(),
                    alignment: Alignment.center,
                  ),
                ],
              ),
              // Ajoutez le reste du code ici
            ),
            const Divider(
              thickness: 1,
              color: Colors.black,
            ), // Ajoute une ligne horizontale
            const SizedBox(height: 10),

            quest.beforeText,
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.topLeft, // Add this line to align the text to the left
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left, // Add this line to align the text to the left
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quest.description,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.left, // Add this line to align the text to the left
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),

            quest.afterText,

            const SizedBox(height: 10),

            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color:
                    iconColor, // Remplacez par votre couleur de fond souhaitée
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextButton(
                onPressed: () {
                  quest.onValidate();
                },
                child: const Text('Valider la quête',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



