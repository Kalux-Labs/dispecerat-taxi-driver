import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final String address;
  final LatLng geometry;

  const Place({
    required this.id,
    required this.address,
    required this.geometry,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> result = json['result'] as Map<String, dynamic>;
    return Place(
      id: result['place_id'] as String,
      address: result['formatted_address'] as String,
      geometry: LatLng(
        result['geometry']['location']['lat'] as double,
        result['geometry']['location']['lng'] as double,
      ),
    );
  }
}
