import 'package:driver/src/business_logic/cubits/location_cubit/location_cubit.dart';
import 'package:driver/src/presentation/error/error_page.dart';
import 'package:driver/src/presentation/error/location_permission_page.dart';
import 'package:driver/src/presentation/loading/loading_page.dart';
import 'package:driver/src/presentation/main/widgets/google_maps_widget.dart';
import 'package:driver/src/presentation/main/widgets/home_page_drawer.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:driver/src/utils/widgets/circled_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.mounted) {
        context.read<LocationCubit>().requestLocationPermission();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppRouter.homePageScaffoldState,
      drawer: const HomePageDrawer(),
      body: BlocConsumer<LocationCubit, LocationState>(
          listener: (BuildContext context, LocationState state) {

          },
          builder: (BuildContext context, LocationState state) {
            if (state is LocationUpdated) {
              return SafeArea(
                child: Stack(
                  children: [
                    GoogleMapsWidget(),
                    Positioned(
                      top: 8,
                        child: CircledIconButton(
                      onPressed: _handleDrawer,
                      iconData: Icons.menu,
                    )),

                  ],
                ),
              );
            } else if (state is LocationPermissionDenied) {
              return const LocationPermissionPage();
            } else if (state is LocationPermissionPermanentlyDenied) {
              return const ErrorPage(
                title: "Permisiuni de locatie",
                description:
                    "Permisiunile de locatie au fost permanent blocate, acceseaza setarile telefonului pentru a le debloca",
              );
            }
            return const LoadingPage();
          }),
    );
  }

  void _handleDrawer() {
    if (AppRouter.homePageScaffoldState.currentState!.isDrawerOpen) {
      AppRouter.homePageScaffoldState.currentState!.openEndDrawer();
    } else {
      AppRouter.homePageScaffoldState.currentState!.openDrawer();
    }
  }
}
