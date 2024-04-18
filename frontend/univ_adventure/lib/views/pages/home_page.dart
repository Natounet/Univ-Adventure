import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:univ_adventure/services/user_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the homepage!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                UserManager.removeUserID();
                Navigator.pushReplacementNamed(context, '/auth');
              },
              child: const Text('Déconnexion'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go("/profile");
              },
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
