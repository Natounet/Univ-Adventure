import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:univ_adventure/components/QuestMiniature.dart';
import 'package:univ_adventure/components/quest_card_location.dart';
import 'package:univ_adventure/models/location.dart';
import 'package:univ_adventure/models/quest.dart';
import 'package:univ_adventure/services/user_manager.dart';

import '../../models/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];
  List<Quest> allQuests = [];

  void fetchCategories() async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref()
        .child(
          "categories",
        )
        .get()
        .catchError((e) => print("Erreur $e"));

    Map<String, dynamic> categoriesData =
        Map<String, dynamic>.from(snapshot.value as Map<Object?, Object?>);
    setState(() {
      categories = categoriesData.entries
          .map(
            (e) => Category.fromJson(
              Map<String, dynamic>.from(e.value as Map<Object?, Object?>),
            ),
          )
          .toList();
    });
  }

  void fetchQuests() async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref()
        .child(
          "quests",
        )
        .get()
        .catchError((e) => print("Erreur $e"));

    setState(() {
      allQuests = snapshot.children
          .map(
            (e) => Quest.fromDatabase(e),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchQuests();
  }

  @override
  Widget build(BuildContext context) {
    int currentLevel = 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Add this line
        children: [
          for (final category in categories)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Add this line
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Add this line
                        children: [
                          Text(
                            category.name,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            category.description,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        LucideIcons.moveHorizontal,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                const Divider(),
                // ShaderMask permet de faire un dégradé vers le transparent sur le bord droit de la liste
                ShaderMask(
                  shaderCallback: (Rect rect) {
                    return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.red
                        ],
                        stops: [
                          0.85,
                          1.0
                        ] // 10% purple, 80% transparent, 10% purple
                        ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final quest in allQuests
                            .where((e) => e.categoryID == category.id)
                            .toList())
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QuestMiniature(
                              quest: quest,
                              currentLevel: currentLevel,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            )
        ],
      ),
    );
  }
}
