import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univ_adventure/models/rewards.dart';
import 'package:univ_adventure/models/location.dart';

class Quest {
  final String questId;
  final String title;
  final int xp;
  final String subtitle;
  final String description;
  final String icon;
  final String category;
  final int categoryLevel;
  final Widget beforeText;
  final Widget afterText;
  final Function onValidate;

  Quest({
    required this.questId,
    required this.title,
    required this.xp,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.category,
    required this.categoryLevel,
    required this.beforeText,
    required this.afterText,
    required this.onValidate,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      questId: json['questId'],
      title: json['name'],
      xp: json['xp'],
      subtitle: json['subtitle'],
      description: json['description'],
      icon: json['icon'],
      category: json['category'],
      categoryLevel: json['category_level'],
      beforeText: json['beforeText'],
      afterText: json['afterText'],
      onValidate: json['onValidate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questId': questId,
      'name': title,
      'xp': xp,
      'subtitle': subtitle,
      'description': description,
      'icon': icon,
      'category': category,
      'category_level': categoryLevel,
      'beforeText': beforeText,
      'afterText': afterText,
      'onValidate': onValidate,
    };
  }
}


/// Loads the quests from the Firestore database.
///
/// Returns a list of [Quest] objects.
Future<List<Quest>> loadQuests() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('quests').get();
  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  return documents.map((doc) => Quest.fromJson(doc.data() as Map<String, dynamic>)).toList();
}

/// Retrieves the completion count of a quest.
///
/// This method queries the Firestore database to retrieve the number of users
/// who have completed a specific quest identified by [questId].
///
/// Returns the completion count as a [Future] of [int].
Future<int> getQuestCompletionCount(String questId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('questsCompleted', arrayContains: questId)
      .get();
  return querySnapshot.docs.length;
}

