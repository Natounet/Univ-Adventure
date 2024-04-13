import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:flutter/services.dart';

class News {
  final String newsId;
  final String title;
  final String description;
  final Optional<Location> location;
  final String date;
  final dynamic startTime;
  final dynamic endTime;
  final String article;
  final Optional<Image> image;

  News({
    required this.newsId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    this.startTime,
    this.endTime,
    required this.article,
    required this.image,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      image: json['image'] != null
          ? Optional.of(Image.asset(json['image']))
          : const Optional.empty(),
      article: json['article'],
      newsId: json['newsId'],
      title: json['title'],
      description: json['description'],
      location: json['location'] != null
          ? Optional.of(Location.fromJson(json['location']))
          : const Optional.empty(),
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

Future<List<News>> loadNews() async {
  String jsonString = await rootBundle.loadString('assets/news.json');
  List<dynamic> jsonResponse = jsonDecode(jsonString);
  return jsonResponse
      .map((quest) => News.fromJson(quest as Map<String, dynamic>))
      .toList();
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
