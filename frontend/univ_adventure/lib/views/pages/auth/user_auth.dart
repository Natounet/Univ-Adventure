import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:univ_adventure/services/user_manager.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  UserAuthState createState() => UserAuthState();
}

class UserAuthState extends State<UserAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showSnackBar(String message, {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _handleUserCredential(UserCredential userCredential) async {
    String userId = userCredential.user!.uid;

    var snapshot =
        await FirebaseDatabase.instance.ref().child("users/$userId").get();

    if (snapshot != null) {
      UserManager.addUserID(userId);
      if (mounted) {
        context.go("/home");
      }
    } else {
      _showSnackBar(
          'Erreur lors de la récupération des informations utilisateur');
    }
  }

  Future<void> _attemptLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        await _handleUserCredential(userCredential);
      } else {
        _showSnackBar('Aucun compte trouvé pour cette adresse email');
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar('Erreur de connexion: ${e.message}');
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showSnackBar(
          'Veuillez entrer votre email pour réinitialiser le mot de passe');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      _showSnackBar('Email de réinitialisation envoyé',
          backgroundColor: Colors.blue);
    } catch (e) {
      _showSnackBar('Erreur lors de l\'envoi de l\'email de réinitialisation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Univ\'Adventure'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/logo.png',
                height:
                    100), // Assurez-vous que 'logo.png' est ajouté dans votre dossier assets
            const SizedBox(
                height: 20), // Add some space between the logo and the card
            Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Adresse email invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Le mot de passe doit contenir au moins 6 caractères';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _attemptLogin(),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(140, 50)),
                            child: const Text('Se connecter'),
                          ),
                          ElevatedButton(
                            onPressed: () => context.go("/signup"),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(140, 50)),
                            child: const Text("Je n'ai pas de compte"),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => _forgotPassword(),
                        child: const Text('Mot de passe oublié ?'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
