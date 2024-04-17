import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMarker extends Marker {
  final String title;
  final String description;

  CustomMarker({
    required this.title,
    required this.description,
    required LatLng point,
    double width = 30.0,
    double height = 30.0,
    Widget Function(BuildContext)? builder,
    VoidCallback? onTap,
    required Widget child,
  }) : super(
          point: point,
          width: width,
          height: height,
          child: const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 50.0,
        )
        );
}