import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:geolocator/geolocator.dart';
import '../../models/quests.dart';
import '../../models/user.dart';
import '../../services/user_manager.dart';

import 'package:permission_handler/permission_handler.dart';

void requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    status = await Permission.camera.request();
    if (!status.isGranted) {
      throw Exception('Camera permission not granted');
    }
  }
}

void requestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
    if (!status.isGranted) {
      throw Exception('Location permission not granted');
    }
  }
}

class QuestDetailPage extends StatelessWidget {
  final Quest quest;
  final User user;

  QuestDetailPage({required this.quest, required this.user});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quest.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description de la quête :",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0), // Espacement entre le titre et la description
                  Text(
                    quest.description,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            if (quest.method == "location")
              
              Container(
                height: 300.0,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(quest.location.latitude, quest.location.longitude!),
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(quest.location.latitude, quest.location.longitude),
                          child: Container(
                            child: Icon(Icons.location_on, size: 40.0, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () => _handleQuestValidation(context),
            child: Text('Valider la quête'),
          ),
        ),
      ),
    );
  }

 void _handleQuestValidation(BuildContext context) async {
  try {
    if (user.questsCompleted.contains(quest.questId)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Quête déjà terminée"),
          content: Text("Vous avez déjà terminé cette quête."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (quest.method == "qrcode") {
      requestCameraPermission();
      String? result = await scanner.scan();
      if (result != null && result == quest.qrCode) {
        // Gestion du succès du scan QR
        UserManager.addPoints(quest.rewards.points);
        for (String badge in quest.rewards.badges) {
          UserManager.addBadge(badge);
        }
        UserManager.validateQuest(quest.questId);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Bien joué !"),
            content: Text("Le QR code est correct!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      } else {
        // Gestion de l'échec du scan QR
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("C'est raté !"),
            content: Text("Le QR code est incorrect."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } else if (quest.method == "location") {
      requestLocationPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          quest.location.latitude,
          quest.location.longitude);
      print(distance);

  
      if (distance < 100) {
        // supposer que 100 mètres est la proximité acceptée
        // Gestion du succès de la localisation

        // Vériier si l'utilisateur a déjà terminé la quête
        
        UserManager.addPoints(quest.rewards.points);
        for (String badge in quest.rewards.badges) {
          UserManager.addBadge(badge);
        }
        

        UserManager.validateQuest(quest.questId);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Succès"),
            content: Text("Vous êtes à proximité du lieu!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      } else {
        // Gestion de l'échec de la localisation
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Échec"),
            content: Text("Vous n'êtes pas assez proche du lieu."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Required"),
          content: Text("${(e as Exception)}. Please grant the necessary permissions in your app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}}