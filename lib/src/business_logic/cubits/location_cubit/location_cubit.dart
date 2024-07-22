import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/repositories/database_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
part 'location_cubit_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final DatabaseRepository _databaseRepository;
  final AppSessionCubit _appSessionCubit;

  LocationCubit(
      {required DatabaseRepository databaseRepository,
      required AppSessionCubit appSessionCubit})
      : _databaseRepository = databaseRepository,
        _appSessionCubit = appSessionCubit,
        super(LocationPermissionInitial());

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
      if (_appSessionCubit.state != null) {
        _databaseRepository.updateDriver(_appSessionCubit.state!.id,
            {"lat": position.latitude, "lng": position.longitude});
      }
      emit(LocationUpdated(
        position: position,
      ));
    });
  }
}
