import 'dart:typed_data';

import 'package:driver/src/utils/app_assets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
part 'location_cubit_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationPermissionInitial());

  final Stream<Position> _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 10));

  Future<void> requestLocationPermission() async {
    emit(LocationPermissionLoading());
    final status = await Permission.location.request();

    if (status.isGranted) {
      await _startTracking();
    } else if (status.isDenied) {
      emit(LocationPermissionDenied());
    } else if (status.isPermanentlyDenied) {
      emit(LocationPermissionPermanentlyDenied());
    }
  }

  Future<void> _startTracking() async {
    _positionStream.listen((Position position) {
      emit(LocationUpdated(
        position: position,
        markers: {}
      ));
    });
  }
}
