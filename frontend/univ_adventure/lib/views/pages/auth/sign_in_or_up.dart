import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInOrUp extends StatelessWidget {
  const SignInOrUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bienvenue !"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/auth/sign-up');
              },
              child: const Text("Première fois ? S'inscrire !"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.go('/auth/sign-in');
              },
              child: const Text("Déjà un compte ? Se connecter ! "),
            ),
          ],
        ));
  }
}
