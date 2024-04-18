
import 'package:flutter/material.dart';
import 'package:univ_adventure/components/quest_card.dart';

import 'package:univ_adventure/views/pages/home_page.dart';
import 'package:univ_adventure/views/pages/quest_detailed.dart';
import 'package:univ_adventure/views/pages/sign_up.dart';
import 'package:univ_adventure/views/pages/user_auth.dart';
import 'package:univ_adventure/views/pages/profile.dart';
import 'package:univ_adventure/models/quest.dart';
import 'package:lucide_icons/lucide_icons.dart';


import 'services/user_manager.dart'; // Assurez-vous d'importer la classe UserManager correctement

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserManager.initialize();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  
  final Quest quest = Quest(
    questId: "1",
    title: "Lac au connard",
    subtitle: "Rends-toi au lac au connard.. canard !",
    description: "Près de l'ISTIC et du batiment 12D ce trouve un petit lac artificiel très sympa.\nRends-y toi et active ta localisation pour valider la quête.",
    icon: LucideIcons.mapPin,
    xp: 300,
    category: "Exploration",
    categoryLevel: 1,
    beforeText: Image(image: const AssetImage("assets/images/carteTest.png")),
    afterText: Container(),
    onValidate: () {
      print("Quête validée !");
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => UserManager.getUserID() == null ? UserAuth() : QuestCard(quest: quest,),
          );
        } else if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) => QuestCard(quest: quest,),
          );
        } else if (settings.name == '/auth') {
          return MaterialPageRoute(
            builder: (context) => const UserAuth(),
          );
        } else if (settings.name == '/signup') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => SignupPage(userID: args['userID'], userEmail: args['userEmail']),
          );
        }
        else if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          );
        }
        // Handle other routes
      },
      title: 'Univ Adventure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}