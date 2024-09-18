// ignore_for_file: unused_import

import 'package:driver/src/business_logic/cubits/location_cubit/location_cubit.dart';
import 'package:driver/src/business_logic/cubits/map_cubit/map_cubit.dart';
import 'package:driver/src/business_logic/cubits/order_cubit/order_cubit.dart';
import 'package:driver/src/presentation/error/error_page.dart';
import 'package:driver/src/presentation/error/location_permission_page.dart';
import 'package:driver/src/presentation/loading/loading_page.dart';
import 'package:driver/src/presentation/main/widgets/accepted_order_modal_bottom_sheet.dart';
import 'package:driver/src/presentation/main/widgets/google_maps_widget.dart';
import 'package:driver/src/presentation/main/widgets/home_page_drawer.dart';
import 'package:driver/src/presentation/main/widgets/new_order_modal_bottom_sheet.dart';
import 'package:driver/src/presentation/main/widgets/top_notification.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppRouter.homePageScaffoldState,
      drawer: const HomePageDrawer(),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (BuildContext context, LocationState state) {
          return BlocConsumer<OrderCubit, OrderState>(
            listener: (BuildContext context, OrderState orderState) {
              if (orderState is OrderReceived) {
                showModalBottomSheet<void>(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return const NewOrderModalBottomSheet();
                  },
                );
              } else if (orderState is OrderAccepted) {
                AppRouter.scaffoldMessengerState.currentState!.showSnackBar(
                  const SnackBar(
                    content: Text('Comanda a fost acceptata'),
                  ),
                );
                // showModalBottomSheet<void>(
                //     context: context,
                //     isDismissible: false,
                //     elevation: 0,
                //     backgroundColor: Colors.transparent,
                //     barrierColor: Colors.white.withOpacity(0),
                //     isScrollControlled: true,
                //     enableDrag: false,
                //     shape: const RoundedRectangleBorder(
                //         borderRadius:
                //             BorderRadius.vertical(top: Radius.circular(16))),
                //     builder: (BuildContext context) {
                //       return const AcceptedOrderModalBottomSheet();
                //     });
              } else if (orderState is OrderExpired) {
                Navigator.pop(context);
                AppRouter.scaffoldMessengerState.currentState!.showSnackBar(
                  const SnackBar(
                    content: Text('Comanda a expirat'),
                  ),
                );
              } else if (orderState is OrderFinished) {
                AppRouter.scaffoldMessengerState.currentState!.showSnackBar(
                  const SnackBar(
                    content: Text('Comanda a fost finalizata'),
                  ),
                );
              }
            },
            builder: (BuildContext context, OrderState orderState) {
              if (state is LocationPermissionGranted) {
                return SafeArea(
                  child: Stack(
                    children: <Widget>[
                      const GoogleMapsWidget(),
                      Positioned(
                        top: 8,
                        child: CircledIconButton(
                          onPressed: _handleDrawer,
                          iconData: Icons.menu,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is LocationPermissionDenied) {
                return const LocationPermissionPage();
              } else if (state is LocationPermissionPermanentlyDenied) {
                return const ErrorPage(
                  title: 'Permisiuni de locatie',
                  description:
                      'Permisiunile de locatie au fost permanent blocate, acceseaza setarile telefonului pentru a le debloca',
                );
              }
              return const LoadingPage();
            },
          );
        },
      ),
    );
  }

  void _handleDrawer() {
    if (AppRouter.homePageScaffoldState.currentState!.isDrawerOpen) {
      AppRouter.homePageScaffoldState.currentState!.openEndDrawer();
    } else {
      AppRouter.homePageScaffoldState.currentState!.openDrawer();
    }
  }

  // void _showTopNotification(BuildContext context) {
  //   final overlay = Overlay.of(context);
  //   late OverlayEntry overlayEntry;
  //
  //   overlayEntry = OverlayEntry(
  //       builder: (context) => Positioned(
  //             top: 20.0,
  //             left: 0.0,
  //             right: 0.0,
  //             child: TopNotification(
  //               callback: () {
  //                 overlayEntry.remove();
  //               },
  //             ),
  //           ));
  //   overlay.insert(overlayEntry);
  //
  //   // Future.delayed(Duration(seconds: 10), () {
  //   //   overlayEntry.remove();
  //   // });
  // }
}
