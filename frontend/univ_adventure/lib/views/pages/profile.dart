import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optional/optional_internal.dart';
import 'package:univ_adventure/models/user.dart';
import 'package:univ_adventure/services/user_manager.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<Optional<User>> getUser() async {
    return await UserManager.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Optional<User>>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else {
          var user = snapshot.data?.value;
          if (user == null) {
            return const Center(
                child: Text('Aucune donnée utilisateur disponible'));
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profil'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Logique pour modifier le profil
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(user.username,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(user.email),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('Genre : ${user.gender}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title:
                        Text('Date de création : ${user.createdAt.toString()}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.score),
                    title: Text('Points : ${user.points}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: const Text('Badges :'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: user.badges
                          .map<Widget>((badge) => Text(badge))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      UserManager.removeUserID();
                      context.go("/auth");
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('Déconnecter'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
