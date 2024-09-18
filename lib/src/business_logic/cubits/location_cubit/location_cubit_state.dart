part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class LocationPermissionInitial extends LocationState {}

class LocationPermissionLoading extends LocationState {}

class LocationPermissionGranted extends LocationState {
  final Position position;

  LocationPermissionGranted({required this.position});

  @override
  List<Object> get props => <Object>[position];
}

class LocationPermissionDenied extends LocationState {}

class LocationPermissionPermanentlyDenied extends LocationState {}
