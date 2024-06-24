part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final LatLng currentLocation;

  MapLoaded(this.currentLocation);
  @override
  List<Object> get props => [currentLocation];
}

class MapError extends MapState {
  final String error;
  MapError(this.error);
  @override
  List<Object> get props => [error];
}

class MapMoved extends MapState {}