part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;

  MapLoaded(
      {
    this.markers = const {},
    this.polylines = const {},
  });
  @override
  List<Object> get props => [markers, polylines];
}

class MapError extends MapState {
  final String error;
  MapError(this.error);
  @override
  List<Object> get props => [error];
}
