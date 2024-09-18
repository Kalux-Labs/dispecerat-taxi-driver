import 'dart:convert' as convert;

import 'package:driver/env/env.dart';
import 'package:driver/src/models/place.dart';
import 'package:http/http.dart' as http;

class GooglePlacesService {
  Future<Place> getPlace(String placeId) async {
    final Uri url = Uri.https('maps.googleapis.com', '/maps/api/place/details/json',
        <String,dynamic >{'placeid': placeId, 'key': Env.googleMapsAPIKey},);

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (json['status'] == 'OK') {
        return Place.fromJson(json);
      } else {
        throw Exception('Failed to load place details: ${json['status']}');
      }
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
