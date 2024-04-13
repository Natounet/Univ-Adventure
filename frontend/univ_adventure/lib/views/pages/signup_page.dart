import 'package:flutter/material.dart';
import 'package:univ_adventure/models/user.dart';
import 'package:univ_adventure/views/pages/home_page.dart';
import '../../services/user_manager.dart'; // Supposons que c'est votre gestionnaire d'utilisateur

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';

  void _trySubmitForm() async {
  final isValid = _formKey.currentState?.validate();
  print('Formulaire invalide: $isValid');

  if (isValid == true) {
    _formKey.currentState?.save();
    print('Nom: $_name, Email: $_email');

    User newUser = User(
        createdAt: DateTime.now(),
        email: _email,
        name: _name,
        userId: 1,
        profilePicture: '');
    UserManager.addUser(newUser);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()));
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Formulaire invalide'),
        content: Text('Veuillez entrer un nom et une adresse mail universitaire valide. (prenom.nom@etudiant.univ-rennes.fr)'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _trySubmitForm,
                child: Text('Envoyer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}