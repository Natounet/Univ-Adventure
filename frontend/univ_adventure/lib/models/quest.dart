import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:univ_adventure/models/rewards.dart';
import 'package:univ_adventure/models/location.dart';

class Quest {
  final String questId;
  final String title;
  final String description;
  final Location location;
  final bool isActive;
  final String qrCode;
  final String method;
  final dynamic? startTime;
  final dynamic? endTime;
  final Rewards rewards;

  Quest({
    required this.questId,
    required this.title,
    required this.description,
    required this.location,
    required this.isActive,
    required this.qrCode,
    required this.method,
    this.startTime,
    this.endTime,
    required this.rewards,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      questId: json['questId'],
      title: json['title'],
      description: json['description'],
      location: Location.fromJson(Map<String, dynamic>.from(json['location'])),
      isActive: json['isActive'],
      qrCode: json['qrCode'],
      method: json['method'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      rewards: Rewards.fromJson(Map<String, dynamic>.from(json['rewards'])),
    );
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

