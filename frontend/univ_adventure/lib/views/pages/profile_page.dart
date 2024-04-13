// lib/views/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:univ_adventure/services/user_manager.dart';
import '../../models/user.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: UserManager.userStream,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          User? user = snapshot.data;
          if (user == null) {
            return Text('Aucun utilisateur trouvé');
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: const Color.fromRGBO(182, 196, 182, 1),
            ),
            body: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgroundProfile.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(user.profilePicture),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Modifier'),
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0), // Add left padding
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            height: 200,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start, // Align texts to the top
                            crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the left
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0), // Add bottom padding
                                child: Text('Nom: ${user.name}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0), // Add bottom padding
                                child: Text('Email: ${user.email}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Text('Date de création: ${user.createdAt}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("Points: ${user.points}" , style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("Quêtes complétées: ${user.questsCompleted.length}" , style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("Badges: ${user.badges.join(",").isEmpty ? "Aucun" : user.badges.join(" - ")}", style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}