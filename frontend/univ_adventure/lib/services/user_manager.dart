import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univ_adventure/models/quests.dart';

class UserManager {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> addUserID(String value) async {
    await _prefs?.setString('userID', value);
  }

  static String? getUserID() => _prefs?.getString('userID');

  static Future<void> removeUserID() async {
    await _prefs?.remove('userID');
  }


  static Future<void> addPoints(int points) async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
      int currentPoints = (userSnapshot.data() as Map<String, dynamic>)['points'] ?? 0;
      int newPoints = currentPoints + points;
      await usersCollection.doc(userID).update({'points': newPoints});
      }
    }
    
  }

  static Future<void> addBadge(String badge) async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
        List<dynamic> currentBadges = (userSnapshot.data() as Map<String, dynamic>)['badges'] ?? [];
        if (!currentBadges.contains(badge)) {
          currentBadges.add(badge);
          await usersCollection.doc(userID).update({'badges': currentBadges});
        }
      }
    } 
  }

  static Future<void> validateQuest(Quest quest) async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
        List<dynamic> questsCompleted = (userSnapshot.data() as Map<String, dynamic>)['questsCompleted'] ?? [];
        if (!questsCompleted.contains(quest.questId)) {
          questsCompleted.add(quest.questId);
          await usersCollection.doc(userID).update({'questsCompleted': questsCompleted});
          addPoints(quest.rewards.points);
          for (String badge in quest.rewards.badges) {
            addBadge(badge);
          }
        }
      }
    }
  }
}