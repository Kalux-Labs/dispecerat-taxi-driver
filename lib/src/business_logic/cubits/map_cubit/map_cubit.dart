import 'package:driver/src/services/google_routes_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';

part 'map_cubit_state.dart';

class MapCubit extends Cubit<MapState> {
  final GoogleRoutesService _googleRoutesService;

  MapCubit({required GoogleRoutesService googleRoutesService})
      : _googleRoutesService = googleRoutesService,
        super(MapInitial());

  Future<void> _addPolyline(
    List<LatLng> polylineCoordinates,
    LatLng destination,
  ) async {
    const PolylineId polylineId = PolylineId('poly');
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blue,
      points: polylineCoordinates,
    );

    const MarkerId markerId = MarkerId('markerId');
    final AssetMapBitmap icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/flag.png',
    );
    final Marker marker =
        Marker(markerId: markerId, icon: icon, position: destination);
    emit(
      MapLoaded(
        markers: <MarkerId, Marker>{markerId: marker},
        polylines: <PolylineId, Polyline>{polylineId: polyline},
      ),
    );
  }

  Future<void> getPolyline(LatLng origin, LatLng destination) async {
    emit(MapLoading());
    try {
      final List<LatLng> polylineCoordinates = await _googleRoutesService
          .getRouteBetweenCoordinates(origin, destination);
      await _addPolyline(polylineCoordinates, destination);
    } catch (error) {
      debugPrint(error.toString());
      emit(MapError(error.toString()));
    }
  }

  void reset() {
    emit(MapLoaded());
  }
}
