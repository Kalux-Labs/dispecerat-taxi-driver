import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_cubit_state.dart';

class MapCubit extends Cubit<MapState> {
  GoogleMapController? _mapController;

  MapCubit() : super(MapInitial());

  void initMapController(GoogleMapController controller) {
    _mapController = controller;
  }
}
