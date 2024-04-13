// lib/views/pages/map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte du campus de Beaulieu'),
      ),
      body: FutureBuilder<List<Marker>>(
        future: getMarkersFromJson(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(48.11739072417471, -1.6383751048627655),
                initialZoom: 16.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'], // serveurs de tuiles OSM
                ),
                MarkerLayer(
                  markers: snapshot.data!,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
Future<List<Marker>> getMarkersFromJson() async {
  // Charger le contenu du fichier JSON
  String jsonContent = await rootBundle.loadString('assets/POI.json');

  // Convertir le contenu JSON en une liste d'objets
  List<dynamic> jsonList = json.decode(jsonContent);

  // Créer des marqueurs à partir des données JSON
  List<Marker> markers = jsonList.map((poi) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(poi['latitude'], poi['longitude']),
      child: const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 50.0,
        ),
    );
  }).toList();

  return markers;
}
