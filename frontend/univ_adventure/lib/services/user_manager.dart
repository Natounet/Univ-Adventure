import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'package:rxdart/rxdart.dart';

class UserManager {
  static SharedPreferences? _prefs;
  static BehaviorSubject<User?> _userController = BehaviorSubject<User?>.seeded(null);

  static Stream<User?> get userStream => _userController.stream;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> isFirstTime() async {
    bool isFirstTime = _prefs?.getBool('first_time') ?? true;
    if (isFirstTime) {
      await _prefs?.setBool('first_time', false);
      await _prefs?.setInt('points', 0);
      await _prefs?.setStringList('badges', []);
    }
    return isFirstTime;
  }

  static User? getUser() {
    String? userString = _prefs?.getString('user');
    if (userString == null) {
      return null;
    }
    User user = User.fromJson(jsonDecode(userString));
    _userController.add(user);
    return user;
  }

  static Future<void> addUser(User user) async {
    await _prefs?.setString('user', jsonEncode(user.toJson()));
    _userController.add(user);
  }

  static Future<void> addPoints(int points) async {
    User? user = getUser();
    if (user != null) {
      user.points += points;
      await _prefs?.setString('user', jsonEncode(user.toJson()));
      _userController.add(user);
    }
  }

  static Future<void> addBadge(String badge) async {
    User? user = getUser();
    if (user != null) {
      user.badges.add(badge);
      await _prefs?.setString('user', jsonEncode(user.toJson()));
      _userController.add(user);
    }
  }

  static int getPoints() {
    User? user = getUser();
    return user?.points ?? 0;
  }

  static List<String> getBadges() {
    User? user = getUser();
    return user?.badges ?? [];
  }



  static Future<void> validateQuest(String questId) async {
  User? user = getUser();
  if (user != null) {
    if (user.questsCompleted.contains(questId)) {
      print('Vous avez déjà terminé cette quête.');
    } else {
      // Validez la quête et ajoutez-la à la liste des quêtes terminées
      // Ajoute les points de la quête aux points de l'utilisateur

      user.questsCompleted.add(questId);
      await _prefs?.setString('user', jsonEncode(user.toJson()));
      _userController.add(user);
      print('Quête terminée avec succès !');
    }
  }
}
}