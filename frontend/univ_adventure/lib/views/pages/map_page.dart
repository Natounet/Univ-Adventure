// lib/views/pages/map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('OpenStreetMap'),
        ),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(48.1177, -1.6383), // Coordonnées du centre de Londres
            zoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'], // serveurs de tuiles OSM
            ),
          ],
        ),
      ),
    );
  }
}
