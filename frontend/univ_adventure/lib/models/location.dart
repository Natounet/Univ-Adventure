import 'package:latlong2/latlong.dart';

class Lieu {
  final String name;
  final LatLng coordinates;

  const Lieu({required this.name, required this.coordinates});

  factory Lieu.fromJson(Map<String, dynamic> json) {
    return Lieu(
      name: json['name'],
      coordinates: LatLng(json['latitude'], json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
  }

  bool haveSameCoords(Lieu other, {double toleranceMeters = 10}) {
    const calculator = Distance(roundResult: false);
    return calculator
            .as(LengthUnit.Meter, other.coordinates, coordinates)
            .abs() <
        toleranceMeters;
  }
}
