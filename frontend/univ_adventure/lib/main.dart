
import 'package:flutter/material.dart';

import 'package:univ_adventure/views/pages/homepage.dart';
import 'package:univ_adventure/views/pages/signUp.dart';
import 'package:univ_adventure/views/pages/userAuth.dart';
import 'package:univ_adventure/views/pages/profile.dart';
import 'views/pages/userAuth.dart';


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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => UserManager.getUserID() == null ? UserAuth() : HomePage(),
          );
        } else if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) => HomePage(),
          );
        } else if (settings.name == '/auth') {
          return MaterialPageRoute(
            builder: (context) => UserAuth(),
          );
        } else if (settings.name == '/signup') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => SignupPage(userID: args['userID'], userEmail: args['userEmail']),
          );
        }
        else if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) => ProfilePage(),
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