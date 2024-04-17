import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../../../models/quests.dart';
import '../../../models/user.dart';
import '../../../services/user_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    status = await Permission.camera.request();
    if (!status.isGranted) {
      throw Exception('La permission de caméra n\'a pas été accordée');
    }
  }
}

class QRQuestPage extends StatelessWidget {
  final Quest quest;
  final User user;

  QRQuestPage({required this.quest, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quest.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Ajoute un padding autour du contenu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description de la quête",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Espace entre le titre et la description
                  Text(
                    quest.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  requestCameraPermission();
                  String? cameraScanResult = await scanner.scan();
                  if (cameraScanResult == quest.qrCode) {
                    if(await UserManager.validateQuest(quest)){
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Bravo !'),
                          content: const Text('Quête validée avec succès !'),
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
                    else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Erreur'),
                          content: const Text('Vous avez déjà terminé cette quête.'),
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
                    
                    } // Assure-toi que la méthode `validateQuest` prend un User comme argument si nécessaire
                  }
                  else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Erreur'),
                        content: const Text('Le QR Code scanné ne correspond pas à la quête.'),
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
                },
                child: const Text('Scanner le QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}