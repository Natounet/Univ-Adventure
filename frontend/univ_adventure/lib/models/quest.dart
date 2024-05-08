import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";
import "package:result_dart/result_dart.dart";
import "package:univ_adventure/models/location.dart";

class Quest {
  final int questId;
  final String title;
  final int xp;
  final String subtitle;
  final String description;
  final String iconPath;
  final int categoryID;
  final int categoryLevel;
  final int unlockLevel;
  final Duration? regularity;
  final List<QuestValidationCondition> validationConditions;

  Quest({
    required this.questId,
    required this.title,
    required this.xp,
    required this.subtitle,
    required this.description,
    required this.iconPath,
    required this.categoryID,
    required this.categoryLevel,
    required this.unlockLevel,
    required this.regularity,
    required this.validationConditions,
  });

  factory Quest.fromDatabase(DataSnapshot snapshot) {
    print(
        "typeof questId: ${snapshot.child("questId").value.runtimeType}, typeof title: ${snapshot.child("title").value.runtimeType}, typeof xp: ${snapshot.child("xp").value.runtimeType}, typeof subtitle: ${snapshot.child("subtitle").value.runtimeType}, typeof description: ${snapshot.child("description").value.runtimeType}, typeof icon: ${snapshot.child("icon").value.runtimeType}, typeof categoryID: ${snapshot.child("categoryID").value.runtimeType}, typeof categoryLevel: ${snapshot.child("categoryLevel").value.runtimeType}, typeof unlockLevel: ${snapshot.child("unlockLevel").value.runtimeType}, typeof regularity: ${snapshot.child("regularity").value.runtimeType}, typeof validationConditions: ${snapshot.child("validationConditions").value.runtimeType}");
    return Quest(
      questId: snapshot.child("questId").value as int,
      title: snapshot.child("title").value as String,
      xp: snapshot.child("xp").value as int,
      subtitle: snapshot.child("subtitle").value as String,
      description: snapshot.child("description").value as String,
      iconPath: snapshot.child("icon").value as String,
      categoryID: snapshot.child("categoryID").value as int,
      categoryLevel: snapshot.child("categoryLevel").value as int,
      unlockLevel: snapshot.child("unlockLevel").value as int,
      regularity: snapshot.child("regularity").exists
          ? Duration(seconds: snapshot.child("regularity").value as int)
          : null,
      validationConditions: snapshot
          .child("validationConditions")
          .children
          .map(
            (conditionSnapshot) =>
                QuestValidationCondition.fromDatabase(conditionSnapshot),
          )
          .toList(),
    );
  }

  factory Quest.fromJson(Map<String, dynamic> json) {
    print(
        "typeof questId: ${json["questId"].runtimeType}, typeof title: ${json["title"].runtimeType}, typeof xp: ${json["xp"].runtimeType}, typeof subtitle: ${json["subtitle"].runtimeType}, typeof description: ${json["description"].runtimeType}, typeof icon: ${json["icon"].runtimeType}, typeof categoryID: ${json["categoryID"].runtimeType}, typeof categoryLevel: ${json["categoryLevel"].runtimeType}, typeof unlockLevel: ${json["unlockLevel"].runtimeType}, typeof regularity: ${json["regularity"].runtimeType}, typeof validationConditions: ${json["validationConditions"].runtimeType}");
    return Quest(
      questId: json["questId"],
      title: json["title"],
      xp: json["xp"],
      subtitle: json["subtitle"],
      description: json["description"],
      iconPath: json["icon"],
      categoryID: json["categoryID"],
      categoryLevel: json["categoryLevel"],
      unlockLevel: json["unlockLevel"],
      regularity: json["regularity"] != null
          ? Duration(seconds: json["regularity"])
          : null,
      validationConditions:
          (json["validationConditions"] as List<Map<String, dynamic>>)
              .map((conditionJson) =>
                  QuestValidationCondition.fromJson(conditionJson))
              .toList(),
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
      "categoryID": categoryID,
      "category_level": categoryLevel,
      "unlockLevel": unlockLevel,
      "regularity": regularity?.inSeconds,
      "validationConditions":
          validationConditions.map((condition) => condition.toJson()).toList(),
    };
  }
}

sealed class QuestValidationCondition {
  Future<Result<String, String>> tryValidate();

  factory QuestValidationCondition.fromDatabase(DataSnapshot snapshot) {
    switch (snapshot.child("condition_type").value as String) {
      case "location":
        return LocationQuestValidationCondition.fromDatabase(snapshot);
      // case "scanQR":
      //   return ScanQRQuestValidationCondition.fromDatabase(snapshot);
      // case "form":
      //   return FormQuestValidationCondition.fromDatabase(snapshot);
      // case "date":
      //   return DateQuestValidationCondition.fromDatabase(snapshot);
      default:
        throw ArgumentError("Invalid type ${snapshot.key}");
    }
  }

  static QuestValidationCondition fromJson(Map<String, dynamic> json) {
    switch (json["condition_type"]) {
      case "location":
        return LocationQuestValidationCondition.fromJson(json);
      case "scanQR":
        return ScanQRQuestValidationCondition.fromJson(json);
      case "form":
        return FormQuestValidationCondition.fromJson(json);
      case "date":
        return DateQuestValidationCondition.fromJson(json);
      default:
        throw ArgumentError("Invalid type ${json["type"]}");
    }
  }

  Map<String, dynamic> toJson();
}

class LocationQuestValidationCondition implements QuestValidationCondition {
  final Lieu lieu;

  LocationQuestValidationCondition(this.lieu);

  @override
  Future<Result<String, String>> tryValidate() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const Failure("Le service de localisation est désactivé");
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.deniedForever) {
      return const Failure(
        "Tu as refusé l'accès à la localisation pour toujours. Vas dans les paramètres pour changer ça.",
      );
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    LatLng userLocation = LatLng(position.latitude, position.longitude);
    double distance = Distance().as(
      LengthUnit.Meter,
      userLocation,
      lieu.coordinates,
    );

    int tolerance = 20;
    if (distance < tolerance) {
      return const Success("Félicitations !");
    } else {
      return Failure(
        "Tu n'es pas au bon endroit ! Distance: $distance m. La tolérance est de $tolerance m.",
      );
    }
  }

  factory LocationQuestValidationCondition.fromDatabase(DataSnapshot snapshot) {
    return LocationQuestValidationCondition(
      Lieu(
        coordinates: LatLng(
          snapshot.child("location/latitude").value as double,
          snapshot.child("location/longitude").value as double,
        ),
        name: snapshot.child("location/name").value as String,
      ),
    );
  }

  factory LocationQuestValidationCondition.fromJson(Map<String, dynamic> json) {
    return LocationQuestValidationCondition(Lieu.fromJson(json["location"]));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "condition_type": "location",
      "location": lieu.toJson(),
    };
  }
}

class ScanQRQuestValidationCondition implements QuestValidationCondition {
  final String qrCode;

  ScanQRQuestValidationCondition(this.qrCode);

  @override
  Future<Result<String, String>> tryValidate() async {
    return const Success("Félicitations !");
  }

  factory ScanQRQuestValidationCondition.fromJson(Map<String, dynamic> json) {
    return ScanQRQuestValidationCondition(json["qr_code"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "condition_type": "scanQR",
      "qr_code": qrCode,
    };
  }
}

class FormQuestValidationCondition implements QuestValidationCondition {
  final Map<String, String> expectedAnswers;
  late Map<String, String> answers;

  FormQuestValidationCondition(this.expectedAnswers) {
    answers = {for (var key in expectedAnswers.keys) key: ""};
  }

  setAnswers(String key, String value) {
    answers[key] = value;
  }

  @override
  Future<Result<String, String>> tryValidate() async {
    for (var entry in expectedAnswers.entries) {
      if (answers[entry.key] != entry.value) {
        return Failure("Mauvaise réponse pour ${entry.key}");
      }
    }
    return const Success("Félicitations !");
  }

  factory FormQuestValidationCondition.fromJson(Map<String, dynamic> json) {
    return FormQuestValidationCondition(
      Map<String, String>.from(json["expected_answers"]),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "condition_type": "form",
      "expected_answers": expectedAnswers,
    };
  }
}

class DateQuestValidationCondition implements QuestValidationCondition {
  final DateTime date;
  final int toleranceMinutes = 5;

  DateQuestValidationCondition(this.date);

  @override
  Future<Result<String, String>> tryValidate() async {
    DateTime now = DateTime.now();
    if (date.difference(now).abs() < Duration(minutes: toleranceMinutes)) {
      return const Success("Félicitations !");
    } else {
      return Failure(
          "C'est pas le bon moment ! Attends ${date.toLocal().toString()}");
    }
  }

  factory DateQuestValidationCondition.fromJson(Map<String, dynamic> json) {
    return DateQuestValidationCondition(DateTime.parse(json["date"]));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "condition_type": "date",
      "date": date.toIso8601String(),
    };
  }
}

class VisitWebsiteQuestValidationCondition implements QuestValidationCondition {
  final String url;

  VisitWebsiteQuestValidationCondition(this.url);

  @override
  Future<Result<String, String>> tryValidate() async {
    // await launchUrl(Uri.parse(url));
    return const Success("Félicitations !");
  }

  factory VisitWebsiteQuestValidationCondition.fromJson(
      Map<String, dynamic> json) {
    return VisitWebsiteQuestValidationCondition(json["url"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "condition_type": "visitWebsite",
      "url": url,
    };
  }
}
