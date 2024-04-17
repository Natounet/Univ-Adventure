import 'dart:async';

import 'package:optional/optional.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univ_adventure/models/quest.dart';
import 'package:univ_adventure/models/user.dart';
import 'package:univ_adventure/models/badge.dart';

class UserManager {
  static SharedPreferences? _prefs;

  /// Initializes the user manager by getting an instance of SharedPreferences.
  ///
  /// This method is used to initialize the user manager by retrieving an instance
  /// of SharedPreferences. It is an asynchronous method that returns a Future
  /// which completes when the initialization is done.
  ///
  /// Example usage:
  /// ```dart
  /// await UserManager.initialize();
  /// ```
  ///
  /// Throws a [PlatformException] if the initialization fails.
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Adds the provided [value] as the userID to the shared preferences.
  /// 
  /// This method is used to store the userID in the shared preferences.
  /// 
  /// Example usage:
  /// ```dart
  /// await UserManager.addUserID('123456');
  /// ```
  static Future<void> addUserID(String value) async {
    await _prefs?.setString('userID', value);
  }

  /// Returns the user ID from the shared preferences.
  /// If the user ID is not found, it returns null.
  static String? getUserID() => _prefs?.getString('userID');

  /// Removes the user ID from the shared preferences.
  ///
  /// This method is used to remove the user ID from the shared preferences.
  /// It is an asynchronous method that returns a `Future<void>`.
  /// 
  /// Example usage:
  /// ```dart
  /// await UserManager.removeUserID();
  /// ```
  static Future<void> removeUserID() async {
    await _prefs?.remove('userID');
  }


  /// Adds points to the user's account.
  ///
  /// This method takes an integer [points] as input and adds it to the user's current points.
  /// It retrieves the user's ID using the [getUserID] method and updates the 'points' field in the Firestore database.
  /// If the user does not exist or the user's ID is null, no action is taken.
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

  /// Adds a badge to the user's profile.
  ///
  /// The [badge] parameter specifies the badge to be added.
  /// This method retrieves the user's ID using the [getUserID] function.
  /// If the user ID is not null, it retrieves the user document from the 'users' collection in Firestore.
  /// If the user document exists, it retrieves the current badges list from the document data.
  /// If the current badges list does not contain the specified badge, it adds the badge to the list.
  /// Finally, it updates the user document in Firestore with the updated badges list.
  ///
  /// Example usage:
  /// ```dart
  /// await UserManager.addBadge('new_badge');
  /// ```
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

  /// Validates a quest for a user.
  ///
  /// This method validates a given [quest] for the current user. It checks if the user has already completed the quest and if not, adds the quest to the user's completed quests list. It also updates the user's points and badges based on the quest rewards.
  ///
  /// The [quest] parameter represents the quest to be validated.
  ///
  /// This method is asynchronous and returns a [Future] that completes with void.
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
          for (Badge badge in quest.rewards.badges) {
            addBadge(badge.name);
          }
        }
      }
    }
  }

  /// Retrieves the points of the current user.
  ///
  /// Returns a [Future] that completes with an [Optional] containing the points as an [int].
  /// If the user is not authenticated or the user document does not exist, it returns an empty [Optional].
  static Future<Optional<int>> getPoints() async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
        int points = (userSnapshot.data() as Map<String, dynamic>)['points'] ?? 0;
        return Optional.of(points);
      }
    }
    return const Optional.empty();
  }

  /// Retrieves the badges associated with the current user.
  ///
  /// Returns a [Future] that completes with an [Optional] containing a list of strings representing the badges,
  /// or an empty [Optional] if the user does not have any badges.
  ///
  /// The badges are retrieved from the Firestore database using the user's ID.
  /// If the user ID is not available, the method returns an empty [Optional].
  ///
  /// Example usage:
  /// ```dart
  /// Optional<List<String>> badges = await UserManager.getBadges();
  /// if (badges.isPresent) {
  ///   List<String> badgeList = badges.value;
  ///   // Do something with the badgeList
  /// } else {
  ///   // User does not have any badges
  /// }
  /// ```
  static Future<Optional<List<String>>> getBadges() async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
        List<dynamic> badges = (userSnapshot.data() as Map<String, dynamic>)['badges'] ?? [];
        return Optional.of(badges.cast<String>());
      }
    }
    return const Optional.empty();
  }

  /// Retrieves the list of completed quests for the current user.
  ///
  /// Returns a [Future] that resolves to an [Optional] containing a [List] of [String] values representing the completed quests.
  /// If the user is not authenticated or if the user document does not exist, an empty [Optional] is returned.
  static Future<Optional<List<String>>> getQuestsCompleted() async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
        List<dynamic> questsCompleted = (userSnapshot.data() as Map<String, dynamic>)['questsCompleted'] ?? [];
        return Optional.of(questsCompleted.cast<String>());
      }
    }
    return const Optional.empty();
  }

  /// Retrieves the account creation date for the current user.
  ///
  /// Returns a [Future] that resolves to an [Optional] containing the account creation date as a [DateTime] object,
  /// or an empty [Optional] if the account creation date is not available.
  ///
  /// The account creation date is obtained by retrieving the user ID using [getUserID], and then querying the Firestore
  /// collection 'users' to fetch the corresponding user document. If the document exists, the 'createdAt' field is
  /// extracted and converted to a [DateTime] object. The account creation date is then wrapped in an [Optional] and returned.
  ///
  /// If the user ID is null or the user document does not exist, an empty [Optional] is returned.
  static Future<Optional<DateTime>> getAccountCreationDate() async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
        Timestamp? creationTimestamp = (userSnapshot.data() as Map<String, dynamic>)['createdAt'];
        if (creationTimestamp != null) {
          DateTime creationDate = creationTimestamp.toDate();
          return Optional.of(creationDate);
        }
      }
    }
    return const Optional.empty();
  }

  /// Retrieves the gender of the current user.
  ///
  /// Returns a [Future] that completes with an [Optional] containing the gender as a [String].
  /// If the user is not authenticated or the user document does not exist, it returns an empty [Optional].
  static Future<Optional<String>> getGender() async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
        String? gender = (userSnapshot.data() as Map<String, dynamic>)['gender'];
        if (gender != null) {
          return Optional.of(gender);
        }
      }
    }
    return const Optional.empty();
  }

  /// Retrieves the entire user object from the Firestore database.
  ///
  /// Returns a [Future] that completes with an [Optional] containing the user object as a [User] instance,
  /// or an empty [Optional] if the user is not found or the user document does not exist.
  ///
  /// The user object is retrieved by querying the Firestore collection 'users' using the user ID obtained from [getUserID].
  /// If the user ID is not available or the user document does not exist, an empty [Optional] is returned.
  static Future<Optional<User>> getUser() async {
    String? userID = getUserID();
    if (userID != null) {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        User user = User.fromMap(userData);
        return Optional.of(user);
      }
    }
    return const Optional.empty();
  }
}