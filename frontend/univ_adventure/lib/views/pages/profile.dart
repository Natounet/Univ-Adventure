import 'package:flutter/material.dart';
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else {
          var user = snapshot.data?.value;
          if (user == null) {
            return Center(child: Text('Aucune donnée utilisateur disponible'));
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profil'),
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
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
                 
                  SizedBox(height: 10),
                  Text(user.username, style: Theme.of(context).textTheme.headline6),
                  Text(user.email),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Genre : ${user.gender}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Date de création : ${user.createdAt.toString()}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.score),
                    title: Text('Points : ${user.points}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.badge),
                    title: Text('Badges :'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: user.badges.map<Widget>((badge) => Text(badge)).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      UserManager.removeUserID();
                      Navigator.pushReplacementNamed(context, '/auth');
                    },
                    child: Text('Déconnecter'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
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
