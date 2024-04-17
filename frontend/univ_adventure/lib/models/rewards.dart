import 'package:univ_adventure/models/badge.dart';

class Rewards {
  final List<Badge> badges;
  final int points;

  Rewards({
    required this.badges,
    required this.points,
  });

  factory Rewards.fromJson(Map<String, dynamic> json) {
    return Rewards(
      badges: List<Badge>.from(json['badges']),
      points: json['points'],
    );
  }
}