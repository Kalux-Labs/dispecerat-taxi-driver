import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  final String address;
  final LatLng geometry;

  const Place(
      {required this.id, required this.address, required this.geometry});

  factory Place.fromJson(Map<String, dynamic> json) {
    final result = json['result'];
    return Place(
        id: result['place_id'],
        address: result['formatted_address'],
        geometry: LatLng(result['geometry']['location']['lat'],
            result['geometry']['location']['lng']));
  }
}
