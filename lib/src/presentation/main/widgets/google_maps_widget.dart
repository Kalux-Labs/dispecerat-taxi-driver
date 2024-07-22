import 'package:driver/src/business_logic/cubits/location_cubit/location_cubit.dart';
import 'package:driver/src/business_logic/cubits/map_cubit/map_cubit.dart';
import 'package:driver/src/business_logic/cubits/order_cubit/order_cubit.dart';
import 'package:driver/src/presentation/main/widgets/accepted_order_modal_bottom_sheet.dart';
import 'package:driver/src/router/app_router.dart';
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
        return BlocConsumer<OrderCubit, OrderState>(
            listener: (BuildContext context, OrderState orderState) {
          debugPrint("CHANGED ORDERSTATE: ${orderState}");
          debugPrint("CHANGED STATE: ${state}");
          if (orderState is OrderAccepted) {
            if (state is LocationUpdated) {
              context.read<MapCubit>().getPolyline(
                  LatLng(state.position.latitude, state.position.longitude),
                  LatLng(orderState.order.coordinates.latitude,
                      orderState.order.coordinates.longitude));
            }
          }
        }, builder: (BuildContext context, OrderState orderState) {
          return BlocConsumer<MapCubit, MapState>(
            listener: (BuildContext context, MapState mapState) {
              if (mapState is MapError) {
                AppRouter.scaffoldMessengerState.currentState!
                    .showSnackBar(SnackBar(
                  content: Text("S-a produs o eroare: ${mapState.error}"),
                ));
              }
            },
            builder: (BuildContext context, MapState mapState) {
              if (state is LocationUpdated) {
                return Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) {
                        context.read<MapCubit>().initMapController(controller);
                      },
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(state.position.latitude,
                              state.position.longitude),
                          zoom: 14),
                      zoomControlsEnabled: false,

                      // rotateGesturesEnabled: false,
                      // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      //   Factory<OneSequenceGestureRecognizer>(
                      //       () => EagerGestureRecognizer()),
                      // },
                      markers: (mapState is MapLoaded)
                          ? Set<Marker>.of(mapState.markers.values)
                          : {},
                      polylines: (mapState is MapLoaded)
                          ? Set<Polyline>.of(mapState.polylines.values)
                          : {},
                    ),
                    if (orderState is OrderAccepted)
                      const AcceptedOrderModalBottomSheet()
                  ],
                );
              }
              return const Text("S-a produs o eroare");
            },
          );
        });
      },
    );
  }
}
