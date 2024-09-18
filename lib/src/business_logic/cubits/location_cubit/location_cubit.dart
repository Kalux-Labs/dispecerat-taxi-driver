import 'dart:async';

import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/repositories/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'location_cubit_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final DatabaseRepository _databaseRepository;
  final AppSessionCubit _appSessionCubit;
  StreamSubscription<Position>? _positionStream;

  LocationCubit({
    required DatabaseRepository databaseRepository,
    required AppSessionCubit appSessionCubit,
  })  : _databaseRepository = databaseRepository,
        _appSessionCubit = appSessionCubit,
        super(LocationPermissionInitial());

  Future<void> requestLocationPermission() async {
    emit(LocationPermissionLoading());
    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      _startTrackingIfNecessary();
    } else if (status.isDenied) {
      emit(LocationPermissionDenied());
    } else if (status.isPermanentlyDenied) {
      emit(LocationPermissionPermanentlyDenied());
    } else {
      emit(LocationPermissionInitial());
    }
  }

  void _startTrackingIfNecessary() {
    _positionStream?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      emit(LocationPermissionGranted(position: position));
      if (_appSessionCubit.state != null) {
        _databaseRepository.updateDriver(
          _appSessionCubit.state!.id,
          <String, dynamic>{
            'lat': position.latitude,
            'lng': position.longitude,
          },
        );
      }
    });
  }

  void reset() {
    _positionStream?.cancel();
    emit(LocationPermissionInitial());
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    // emit(LocationPermissionInitial());
    return super.close();
  }
}
