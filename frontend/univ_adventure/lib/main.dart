import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:univ_adventure/views/pages/home_page.dart';
import 'services/user_manager.dart'; // Assurez-vous d'importer la classe UserManager correctement
import 'models/user.dart'; // Assurez-vous d'importer la classe User correctement  
import 'package:shared_preferences/shared_preferences.dart';
import 'views/pages/signup_page.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUser(User user) async {
    final userData = user.toJson();
    await _preferences.setString('user', jsonEncode(userData));
  }

  static User? getUser() {
    final userData = _preferences.getString('user');
    return userData == null ? null : User.fromJson(jsonDecode(userData));
  }

  static bool isFirstTime() {
    bool firstTime = _preferences.getBool('first_time') ?? true;
    if (firstTime) {
      _preferences.setBool('first_time', false);
    }
    return firstTime;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  bool isFirstTime = UserPreferences.isFirstTime();

  // Initialize UserManager and set the initial user
  UserManager.initialize();
  User? initialUser = UserPreferences.getUser();
  if (initialUser != null) {
    UserManager.addUser(initialUser);
  }

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  MyApp({required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isFirstTime 
        ? SignupPage() 
        : HomePage(),
    );
  }
}