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
    print('Form is valid: $isValid');

    if (isValid == true) {
      _formKey.currentState?.save();
      print('Name: $_name, Email: $_email');

      User newUser = User(
          createdAt: DateTime.now(),
          email: _email,
          name: _name,
          userId: 1,
          profilePicture: 'https://example.com/image.jpg');
      UserManager.addUser(newUser);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print('Form is not valid');
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
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _trySubmitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}