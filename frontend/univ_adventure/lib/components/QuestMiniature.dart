import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:univ_adventure/components/badge.dart';
import 'package:univ_adventure/components/xp.dart';
import 'package:univ_adventure/models/quest.dart';
import 'package:univ_adventure/models/badge.dart';

// Une miniature de quête, pour la page d'accueil
class QuestMiniature extends StatelessWidget {
  final Quest quest;
  int currentLevel;
  final double width = 120.0;

  QuestMiniature({required this.quest, required this.currentLevel, super.key});

  bool unlocked() {
    return quest.unlockLevel <= currentLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 211, // hauteur minimale avec deux ligne de titre
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          unlocked()
              ? const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
                  ),
                )
              : Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 211, 211, 211),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.lock,
                    size: 60.0,
                  ),
                ),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  quest.title,
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                unlocked()
                    ? XPComponent(
                        xp: quest.xp,
                        scale: 1.0,
                      )
                    : Text(
                        "Niveau ${quest.unlockLevel + 1}",
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
