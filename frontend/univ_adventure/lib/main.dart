import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:univ_adventure/models/location.dart';
import 'package:univ_adventure/models/quest.dart';
import 'package:univ_adventure/views/pages/auth/sign_in_or_up.dart';

import 'package:univ_adventure/views/pages/home_page.dart';
import 'package:univ_adventure/views/pages/auth/sign_up.dart';
import 'package:univ_adventure/views/pages/auth/user_auth.dart';
import 'package:univ_adventure/views/pages/profile.dart';

import 'services/user_manager.dart'; // Assurez-vous d'importer la classe UserManager correctement

import 'package:firebase_core/firebase_core.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'firebase_options.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => UserManager.getUserID() == null
          ? const SignInOrUp()
          : const HomePage(),
    ),
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Univ Adventure'),
        ),
        body: child,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            if (index == 0) {
              context.go("/home");
            } else if (index == 1) {
              context.go("/classement");
            } else if (index == 2) {
              context.go("/market");
            }
          },
          selectedIndex: ["/home", "/classement", "/market"]
                  .indexOf(state.matchedLocation) ??
              0,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(LucideIcons.scroll),
              label: "Accueil",
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.trophy),
              label: "Classement",
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.store),
              label: "Marché",
            )
          ],
        ),
      ),
      routes: [
        GoRoute(
          path: "/home",
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: "/classement",
          builder: (context, state) => Container(),
        ),
        GoRoute(
          path: "/market",
          builder: (context, state) => Container(),
        )
      ],
    ),
    GoRoute(
      path: "/auth/sign-in",
      builder: (context, state) => const UserAuth(),
    ),
    GoRoute(
      path: "/auth/sign-up",
      builder: (context, state) => SignupPage(),
    ),
    GoRoute(
      path: "/profile",
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserManager.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Univ Adventure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
