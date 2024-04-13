import 'package:flutter/material.dart';
import 'package:univ_adventure/services/user_manager.dart';
import '../../models/user.dart';
import 'package:intl/intl.dart';


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
          else {
            print(user.profilePicture);
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: Colors.teal,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: user.profilePicture == '' 
                                  ? const AssetImage('assets/images/defaultProfile.jpg') 
                                  : NetworkImage(user.profilePicture) as ImageProvider<Object>?,
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                    Text(user.email, style: TextStyle(color: Colors.white70, fontSize: 18)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () {}, // TODO: Implement profile editing functionality
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InfoTile(label: "Date de création", value: DateFormat('dd-MM-yyyy').format(user.createdAt)),
                            InfoTile(label: "Points", value: user.points.toString()),
                            InfoTile(label: "Quêtes complétées", value: user.questsCompleted.length.toString()),
                            InfoTile(label: "Badges", value: user.badges.join(", ").isEmpty ? "Aucun" : user.badges.join(", ")),
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
      },
    );
  }

  
}


class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}