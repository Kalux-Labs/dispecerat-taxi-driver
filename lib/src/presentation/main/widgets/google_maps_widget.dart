import 'package:driver/src/business_logic/cubits/location_cubit/location_cubit.dart';
import 'package:driver/src/business_logic/cubits/map_cubit/map_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({super.key});

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (BuildContext context, LocationState state) {
        return BlocBuilder<MapCubit, MapState>(
          builder: (BuildContext context, MapState mapState) {
            if (state is LocationUpdated) {
              return GoogleMap(
                  onMapCreated: (controller) {
                    context.read<MapCubit>().initMapController(controller);
                  },
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          state.position.latitude, state.position.longitude),
                      zoom: 14),
                  zoomControlsEnabled: false,
                  rotateGesturesEnabled: false,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer()),
                  }
                  // markers: state.markers,
                  );
            }
            return Text("S-a produs o eroare");
          },
        );
      },
    );
  }
}
