import 'dart:convert';

import 'package:flutter/services.dart';

class Quest {
  final String questId;
  final String title;
  final String description;
  final Location location;
  final bool isActive;
  final String qrCode;
  final String method;
  final dynamic startTime;
  final dynamic endTime;
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

Future<List<Quest>> loadQuests() async {
  String jsonString = await rootBundle.loadString('assets/quests.json');
  List<dynamic> jsonResponse = jsonDecode(jsonString);
  return jsonResponse.map((quest) => Quest.fromJson(quest as Map<String, dynamic>)).toList();
}

class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class Rewards {
  final List<String> badges;
  final int points;

  Rewards({
    required this.badges,
    required this.points,
  });

  factory Rewards.fromJson(Map<String, dynamic> json) {
    return Rewards(
      badges: List<String>.from(json['badges']),
      points: json['points'],
    );
  }
}

