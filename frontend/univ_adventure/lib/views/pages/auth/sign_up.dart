import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:univ_adventure/services/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_validator/string_validator.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _selectedGender = "Homme";
  String username = "";
  String userEmail = "";
  String password = "";
  String passwordConfirmation = "";
  final genderOptions = ["Masculin", "Féminin", "Neutre"];

  Future<void> createUser(String email) async {
    final sanitizedEmail = trim(escape(email));
    if (!isEmail(sanitizedEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adresse email invalide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final sanitizedUsername = trim(escape(username));

    UserCredential creds = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création du compte : $error'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );

    if (creds.user != null) {
      FirebaseDatabase.instance.ref().child("users/${creds.user!.uid}").set({
        'userID': creds.user!.uid,
        'email': sanitizedEmail,
        'username': sanitizedUsername,
        'gender': _selectedGender,
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création du compte : $error'),
            backgroundColor: Colors.red,
          ),
        );

        //remove the user from the auth database
        creds.user!.delete();
      });

      UserManager.addUserID(creds.user!.uid);
    }

    // Create a new user document in the 'users' collection
  }

  bool strongPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'A-Z]'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue !'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Nom d\'utilisateur'),
                  helperText:
                      "C'est comme ça que les autres joueurs vous verront",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  username = value;
                }),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Adresse email'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse email';
                  } else if (!isEmail(value)) {
                    return 'Adresse email invalide';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    userEmail = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Mot de passe'),
                  helperText:
                      "Doit contenir au moins 8 caractères, une lettre majuscule et un chiffre",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  } else if (!strongPassword(value)) {
                    return 'Le mot de passe doit contenir au moins 8 caractères, une lettre majuscule et un chiffre';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Confirmer le mot de passe'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  if (value != password) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    passwordConfirmation = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Choisis le genre par lequel tu souhaite être appelé·e."),
              ),
              Column(
                children: [
                  for (final option in genderOptions)
                    ListTile(
                      title: Text(option),
                      leading: Radio<String>(
                        value: option,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (userEmail.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez remplir tous les champs'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (strongPassword(password)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Votre mot de passe est trop faible'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    createUser(userEmail).then((value) => context.go('/home'));
                  }
                },
                child: const Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
