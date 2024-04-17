import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univ_adventure/services/user_manager.dart';

class UserAuth extends StatefulWidget {
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  Future<void> _attemptSignup() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await _handleUserCredential(userCredential);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur d\'inscription'),
              content: Text('Un compte existe déjà avec cette adresse email.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
              backgroundColor: Colors.red[200], // Add a reddish color
            );
          },
        );
      } else if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur d\'inscription'),
              content: Text('Le mot de passe est trop faible.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
              backgroundColor: Colors.red[200], // Add a reddish color
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur d\'inscription'),
              content: Text(e.message ?? 'Une erreur inconnue est survenue.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
              backgroundColor: Colors.red[200], // Add a reddish color
            );
          },
        );
      }
    }
  }

  Future<void> _attemptLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await _handleUserCredential(userCredential);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur de connexion'),
              content: Text('Aucun compte n\'existe pour cette adresse email.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
              backgroundColor: Colors.red[200], // Add a reddish color
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur de connexion'),
              content: Text('L\'adresse email est invalide.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
              backgroundColor: Colors.red[200], // Add a reddish color
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur de connexion'),
              content: Text('Le mot de passe est incorrect.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
              backgroundColor: Colors.red[200], // Add a reddish color
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur de connexion'),
              content: Text(e.message ?? 'Une erreur inconnue est survenue.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
              backgroundColor: Colors.red[200], // Add a reddish color
            );
          },
        );
      }
    }
  }

  Future<void> _forgotPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email envoyé'),
            content: Text(
                'Si un compte existe avec et email, un email de réinitialisation du mot de passe a été envoyé à ${_emailController.text}.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        // On répète la même chose en cas d'erreur pour ne pas leak d'informations
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email envoyé'),
            content: Text(
                'Si un compte existe avec et email, un email de réinitialisation du mot de passe a été envoyé à ${_emailController.text}.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _handleUserCredential(UserCredential userCredential) async {
    String userId = userCredential.user!.uid;

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      UserManager.addUserID(userId);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushNamed(context, '/signup',
          arguments: {'userID': userId, 'userEmail': userCredential.user!.email});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de connexion'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _attemptLogin,
                  child: Text('Se connecter'),
                ),
                ElevatedButton(
                  onPressed: _attemptSignup,
                  child: Text('S\'inscrire'),
                ),
              ],
            ),
            TextButton(
              onPressed: _forgotPassword,
              child: Text('Mot de passe oublié'),
            ),
          ],
        ),
      ),
    );
  }
}