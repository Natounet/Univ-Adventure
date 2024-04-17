import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/quests.dart';
import '../../../models/user.dart';
import '../../../services/user_manager.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
    if (!status.isGranted) {
      throw Exception('La permission de localisation n\'a pas été accordée');
    }
  }
}

class LocationQuestPage extends StatelessWidget {
  final Quest quest;
  final User user;

  const LocationQuestPage({Key? key, required this.quest, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quest.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Description de la quête",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10), // Adjust this value to change the space
          Text(
            quest.description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
                    SizedBox(height: 10), // Adjust this value to change the space
          SizedBox(
            height: 300.0,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(quest.location.latitude, quest.location.longitude),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(quest.location.latitude, quest.location.longitude),
                      child:const Icon(Icons.location_on, color: Colors.red, size: 40.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await requestLocationPermission();
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                double distance = Geolocator.distanceBetween(position.latitude, position.longitude, quest.location.latitude, quest.location.longitude);
                if (distance <= 100) {
                  if(await UserManager.validateQuest(quest)){
                    // Show dialog
                    if (Navigator.canPop(context)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
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
                          );
                        },
                      );
                    }
                  }
                  else{
                    // Show dialog
                    if (Navigator.canPop(context)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
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
                          );
                        },
                      );
                    }
                  }
                }
                else{
                  // Show dialog
                  if (Navigator.canPop(context)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text('Erreur'),
                          content: const Text('Vous n\'êtes pas à proximité du lieu de la quête.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Okay'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: const Text('Valider la quête'),
            ),
          ),
        ],
      ),
    );
  }
}