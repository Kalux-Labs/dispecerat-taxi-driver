part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class LocationUpdated extends LocationState {
  final Position position;

  LocationUpdated({required this.position});

  @override
  List<Object> get props => <Object>[position];
}

class LocationPermissionInitial extends LocationState {}
class LocationPermissionLoading extends LocationState {}
class LocationPermissionGranted extends LocationState {}
class LocationPermissionDenied extends LocationState {}
class LocationPermissionPermanentlyDenied extends LocationState {}
