import 'package:driver/env/env.dart';
import 'package:driver/src/models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GooglePlacesService {
  Future<Place> getPlace(String placeId) async {
    var url = Uri.https('maps.googleapis.com', '/maps/api/place/details/json',
        {'placeid': placeId, 'key': Env.googleMapsAPIKey});

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
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
