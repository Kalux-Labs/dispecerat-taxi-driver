part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationUpdated extends LocationState {
  final Position position;
  final Set<Marker> markers;

  LocationUpdated({required this.position, required this.markers});

  @override
  List<Object> get props => [position, markers];
}

class LocationPermissionInitial extends LocationState {}
class LocationPermissionLoading extends LocationState {}
class LocationPermissionGranted extends LocationState {}
class LocationPermissionDenied extends LocationState {}
class LocationPermissionPermanentlyDenied extends LocationState {}

