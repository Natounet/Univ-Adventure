import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:univ_adventure/models/location.dart";
import "package:tuple/tuple.dart";

class Quest {
  final String questId;
  final String title;
  final int xp;
  final String subtitle;
  final String description;
  final String iconPath;
  final String category;
  final int categoryLevel;
  final String questType;

  Quest({
    required this.questId,
    required this.title,
    required this.xp,
    required this.subtitle,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.categoryLevel,
    required this.questType,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      questId: json["questId"],
      title: json["title"],
      xp: json["xp"],
      subtitle: json["subtitle"],
      description: json["description"],
      iconPath: json["icon"],
      category: json["category"],
      categoryLevel: json["category_level"],
      questType: json["questType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "questId": questId,
      "title": title,
      "xp": xp,
      "subtitle": subtitle,
      "description": description,
      "icon": iconPath,
      "category": category,
      "category_level": categoryLevel,
      "questType": questType,
    };
  }
}

class QuestLocation extends Quest {
  final Location location;
  final String imagePath; // Add this line

  QuestLocation({
    required String questId,
    required String title,
    required int xp,
    required String subtitle,
    required String description,
    required String iconPath,
    required String category,
    required int categoryLevel,
    required String questType,
    required this.location,
    required this.imagePath, // Add this line
  }) : super(
          questId: questId,
          title: title,
          xp: xp,
          subtitle: subtitle,
          description: description,
          iconPath: iconPath,
          category: category,
          categoryLevel: categoryLevel,
          questType: questType,
        );

  factory QuestLocation.fromJson(Map<String, dynamic> json) {
    return QuestLocation(
      questId: json["questId"],
      title: json["title"],
      xp: json["xp"],
      subtitle: json["subtitle"],
      description: json["description"],
      iconPath: json["icon"],
      category: json["category"],
      categoryLevel: json["category_level"],
      location: Location.fromJson(json["location"]),
      imagePath: json["imagePath"], // Add this line
      questType: json["questType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "questId": questId,
      "title": title,
      "xp": xp,
      "subtitle": subtitle,
      "description": description,
      "icon": iconPath,
      "category": category,
      "category_level": categoryLevel,
      "location": location.toJson(),
      "imagePath": imagePath, // Add this line
      "questType": questType,
    };
  }
}

class QuestQR extends Quest {
  final String qrCode;

  QuestQR({
    required String questId,
    required String title,
    required int xp,
    required String subtitle,
    required String description,
    required String iconPath,
    required String category,
    required int categoryLevel,
    required String questType,
    required this.qrCode,
  }) : super(
          questId: questId,
          title: title,
          xp: xp,
          subtitle: subtitle,
          description: description,
          iconPath: iconPath,
          category: category,
          categoryLevel: categoryLevel,
          questType: questType,
        );

  factory QuestQR.fromJson(Map<String, dynamic> json) {
    return QuestQR(
      questId: json["questId"],
      title: json["title"],
      xp: json["xp"],
      subtitle: json["subtitle"],
      description: json["description"],
      iconPath: json["icon"],
      category: json["category"],
      categoryLevel: json["category_level"],
      qrCode: json["qrCode"],
      questType: json["questType"],
    );
  }
}

class QuestForm extends Quest {
  final List<(String, String)> form;

  QuestForm({
    required String questId,
    required String title,
    required int xp,
    required String subtitle,
    required String description,
    required String iconPath,
    required String category,
    required int categoryLevel,
    required String questType,
    required this.form,
  }) : super(
          questId: questId,
          title: title,
          xp: xp,
          subtitle: subtitle,
          description: description,
          iconPath: iconPath,
          category: category,
          categoryLevel: categoryLevel,
          questType: questType,
        );

  factory QuestForm.fromJson(Map<String, dynamic> json) {
    List<(String, String)> form = [];
    for (var item in json["form"]) {
      form.add((item["key"], item["value"]));
    }
    return QuestForm(
      questId: json["questId"],
      title: json["title"],
      xp: json["xp"],
      subtitle: json["subtitle"],
      description: json["description"],
      iconPath: json["icon"],
      category: json["category"],
      categoryLevel: json["category_level"],
      form: form,
      questType: json["questType"],
    );
  }
}

/// Loads the quests from the Firestore database.
///
/// Returns a list of [Quest] objects.
Future<List<Quest>> loadQuests() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("quests").get();
  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  List<Quest> quests = [];
  for (var doc in documents) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String questType = data["questType"];
    switch (questType) {
      case "location":
        quests.add(QuestLocation.fromJson(data));
        break;
      case "qr":
        quests.add(QuestQR.fromJson(data));
        break;
      case "form":
        quests.add(QuestForm.fromJson(data));
        break;
      default:
        quests.add(Quest.fromJson(data));
        break;
    }
  }
  return quests;
}

/// Retrieves the completion count of a quest.
///
/// This method queries the Firestore database to retrieve the number of users
/// who have completed a specific quest identified by [questId].
///
/// Returns the completion count as a [Future] of [int].
Future<int> getQuestCompletionCount(String questId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("users")
      .where("questsCompleted", arrayContains: questId)
      .get();
  return querySnapshot.docs.length;
}
