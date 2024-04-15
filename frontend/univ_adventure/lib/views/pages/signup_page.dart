import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:univ_adventure/views/pages/home_page.dart';
import 'package:univ_adventure/services/user_manager.dart';
import 'package:univ_adventure/models/user.dart';


class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _name = '';

  void _trySubmitForm() async {
  final isValid = _formKey.currentState?.validate();

  if (isValid == true) {
    _formKey.currentState?.save();

    try {
      Auth.UserCredential userCredential = await Auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      if (mounted) {

        // Créer un nouvel utilisateur avec le UserManager
        UserManager.addUser(User(
          userId: userCredential.user!.uid,
          name: _name,
          email: _email,
          profilePicture: '',
          createdAt: DateTime.now(),
          questsCompleted: [],
          badges: [],
        ));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Erreur'),
            content: Text('Une erreur s\'est produite lors de la création de l\'utilisateur. Veuillez réessayer. ${e.toString()}'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  } else {
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Formulaire invalide'),
          content: const Text('Veuillez entrer un nom et une adresse mail universitaire valide. (prenom.nom@etudiant.univ-rennes.fr)'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer votre adresse mail étudiante';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9.]+@etudiant\.univ-rennes\.fr$').hasMatch(value)) {
                    return 'Veuillez entrer une adresse mail valide';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _trySubmitForm,
                child: const Text('Envoyer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}