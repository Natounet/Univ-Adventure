// lib/views/pages/map_page.dart
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:univ_adventure/views/pages/CustomMarker.dart';


class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: FutureBuilder<List<CustomMarker>>(
        future: getMarkersFromJson(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(48.11739072417471, -1.6383751048627655),
                initialZoom: 16.0,
                onTap: (tapPosition, point) => print(snapshot.data!)),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'], // serveurs de tuiles OSM
                ),
                PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            markers: snapshot.data! as List<Marker>,
            popupDisplayOptions: PopupDisplayOptions(
              builder: (BuildContext context, Marker marker) =>
                  AlertDialog(
                    title:Text((marker as CustomMarker).title),
                    content:Text(marker.description)
                  )
            ),
          ),
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
Future<List<CustomMarker>> getMarkersFromJson() async {
  // Charger le contenu du fichier JSON
  String jsonContent = await rootBundle.loadString('assets/POI.json');

  // Convertir le contenu JSON en une liste d'objets
  List<dynamic> jsonList = json.decode(jsonContent);

  // Créer des marqueurs à partir des données JSON
  List<CustomMarker> markers = jsonList.map((poi) {
    return CustomMarker(
      title:poi['name'],
      description: poi['description'],
      width: 80.0,
      height: 80.0,
      point: LatLng(poi['latitude'], poi['longitude']),
      child: AlertDialog(title:Text(poi['name']),content:Text(poi['description'])),
    );
  }).toList();

  return markers;
}
