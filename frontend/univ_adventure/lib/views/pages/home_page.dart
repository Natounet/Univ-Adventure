import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:univ_adventure/services/user_manager.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the homepage!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                UserManager.removeUserID();
                Navigator.pushReplacementNamed(context, '/auth');
              },
              child: Text('Déconnexion'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go("/profile");
              },
              child: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
