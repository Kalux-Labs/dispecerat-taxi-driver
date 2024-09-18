import 'package:driver/env/env.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleRoutesService {
  final PolylinePoints _polylinePoints;

  GoogleRoutesService() : _polylinePoints = PolylinePoints();

  Future<List<LatLng>> getRouteBetweenCoordinates(
      LatLng origin, LatLng destination,) async {
    final List<LatLng> polylineCoordinates = <LatLng>[];

    final PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Env.googleMapsAPIKey,
        request: PolylineRequest(
            origin: PointLatLng(origin.latitude, origin.longitude),
            destination:
                PointLatLng(destination.latitude, destination.longitude),
            mode: TravelMode.driving,),);

    if (result.points.isNotEmpty) {
      for (final PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    return polylineCoordinates;
  }
}
