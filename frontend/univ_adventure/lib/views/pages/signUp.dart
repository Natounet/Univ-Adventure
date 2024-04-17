import 'package:flutter/material.dart';
import 'package:univ_adventure/services/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  final String userID;
  final String userEmail;

  SignupPage({Key? key, required this.userID, required this.userEmail}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();

  void createUser(String username) {
    UserManager.addUserID(widget.userID); // Add the user's ID to the shared preferences

    // Create a new user document in the 'users' collection
    FirebaseFirestore.instance.collection('users').doc(widget.userID).set({
      'userID': widget.userID, // Add the user's ID to the document (this is the document ID)
      'username': username,
      'email': widget.userEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'points': 0,  
      'badges': [],
      'questsCompleted': [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page d\'inscription'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue !',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Comment souhaites-tu être appelé?',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createUser(_usernameController.text);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}