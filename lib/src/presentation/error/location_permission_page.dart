import 'package:driver/src/business_logic/cubits/location_cubit/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                "Aplicatia necesita permisiuni de locatie ale telefonului."),
            ElevatedButton(
                onPressed: () {
                  context.read<LocationCubit>().requestLocationPermission();
                },
                child: const Text("Aproba permisiunile."))
          ],
        ),
      ),
    );
  }
}
