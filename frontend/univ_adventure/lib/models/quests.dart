import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Quest {
  final String questId;
  final String title;
  final String description;
  final Map<String, double> location;
  final bool isActive;
  final String qrCode;
  final String method;
  final dynamic startTime;
  final dynamic endTime;
  final Map<String, dynamic> rewards;

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
      location: Map<String, double>.from(json['location']),
      isActive: json['isActive'],
      qrCode: json['qrCode'],
      method: json['method'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      rewards: Map<String, dynamic>.from(json['rewards']),
    );
  }
}

Future<List<Quest>> loadQuests() async {
  String jsonString = await rootBundle.loadString('assets/quests.json');
  List<dynamic> jsonResponse = jsonDecode(jsonString);
  return jsonResponse.map((quest) => Quest.fromJson(quest)).toList();
}