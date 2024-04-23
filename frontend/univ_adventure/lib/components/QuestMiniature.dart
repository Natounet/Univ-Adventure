import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:univ_adventure/components/badge.dart';
import 'package:univ_adventure/components/xp.dart';
import 'package:univ_adventure/models/quest.dart';
import 'package:univ_adventure/models/badge.dart';

class QuestMiniature extends StatelessWidget {
  final Quest quest;
  final double width = 120.0;

  const QuestMiniature({required this.quest, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  quest.title,
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                XPComponent(
                  xp: quest.xp,
                  scale: 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
