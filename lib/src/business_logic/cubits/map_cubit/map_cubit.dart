import 'package:driver/src/services/google_routes_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_cubit_state.dart';

class MapCubit extends Cubit<MapState> {
  final GoogleRoutesService _googleRoutesService;

  MapCubit({required GoogleRoutesService googleRoutesService})
      : _googleRoutesService = googleRoutesService,
        super(MapInitial());

  late final GoogleMapController _mapController;

  void initMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addPolyline(List<LatLng> polylineCoordinates) {
    final polylineId = PolylineId("poly");
    final polyline = Polyline(
        polylineId: polylineId,
        color: Colors.blue,
        points: polylineCoordinates);

    final currentState = state;
    if (currentState is MapLoaded) {
      final polylines = Map<PolylineId, Polyline>.from(currentState.polylines)
        ..[polylineId] = polyline;
      emit(MapLoaded(markers: currentState.markers, polylines: polylines));
    } else {
      emit(MapLoaded(markers: const {}, polylines: {polylineId: polyline}));
    }
  }

  void getPolyline(LatLng origin, LatLng destination) async {
    emit(MapLoading());
    try {
      List<LatLng> polylineCoordinates = await _googleRoutesService
          .getRouteBetweenCoordinates(origin, destination);
      debugPrint(polylineCoordinates.toString());
      _addPolyline(polylineCoordinates);
    } catch (error) {
      debugPrint(error.toString());
      emit(MapError(error.toString()));
    }
  }

  void reset() {
    emit(MapLoaded(markers: const {}, polylines: const {}));
  }
}
