import 'dart:convert';

class User {
   int userId;
   String name;
   String email;
   String profilePicture;
   DateTime createdAt;
   List<String> questsCompleted;
   int points;
   List<String> badges;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.createdAt,
    this.questsCompleted = const [],
    this.points = 0,
    this.badges = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      'questsCompleted': jsonEncode(questsCompleted),
      'points': points,
      'badges': jsonEncode(badges),
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      createdAt: DateTime.parse(json['createdAt']),
      questsCompleted: (jsonDecode(json['questsCompleted']) as List).cast<String>(),
      points: json['points'],
      badges: (jsonDecode(json['badges']) as List).cast<String>(),
    );
  }
}