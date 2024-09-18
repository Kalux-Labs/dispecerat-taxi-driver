import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driver/src/business_logic/cubits/app_info_cubit.dart';
import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/business_logic/cubits/app_theme_cubit.dart';
import 'package:driver/src/business_logic/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:driver/src/business_logic/cubits/connectivity_cubit/connectivity_cubit.dart';
import 'package:driver/src/business_logic/cubits/location_cubit/location_cubit.dart';
import 'package:driver/src/business_logic/cubits/map_cubit/map_cubit.dart';
import 'package:driver/src/business_logic/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:driver/src/business_logic/cubits/order_cubit/order_cubit.dart';
import 'package:driver/src/repositories/authentication_repository.dart';
import 'package:driver/src/repositories/database_repository.dart';
import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:driver/src/repositories/secure_storage_repository.dart';
import 'package:driver/src/services/google_places_service.dart';
import 'package:driver/src/services/google_routes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: <RepositoryProvider<dynamic>>[
          RepositoryProvider<DatabaseRepository>(
              create: (BuildContext context) => DatabaseRepository(),),
          RepositoryProvider<FirestoreRepository>(
              create: (BuildContext context) => FirestoreRepository(),),
          RepositoryProvider<AuthenticationRepository>(
              create: (BuildContext context) => AuthenticationRepository(),),
          RepositoryProvider<SecureStorageRepository>(
              create: (BuildContext context) => SecureStorageRepository(),),
          RepositoryProvider<GooglePlacesService>(
            create: (BuildContext context) => GooglePlacesService(),
          ),
          RepositoryProvider<GoogleRoutesService>(
              create: (BuildContext context) => GoogleRoutesService(),),
        ],
        child: MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<NotificationsCubit>(
                create: (BuildContext context) => NotificationsCubit(
                    firestoreRepository: context.read<FirestoreRepository>(),),),
            BlocProvider<AppThemeCubit>(
                create: (BuildContext context) => AppThemeCubit(),),
            BlocProvider<AppSessionCubit>(
              create: (BuildContext context) => AppSessionCubit(
                  firestoreRepository: context.read<FirestoreRepository>(),
                  databaseRepository: context.read<DatabaseRepository>(),),
            ),
            BlocProvider<AuthenticationCubit>(
                create: (BuildContext context) => AuthenticationCubit(
                    authenticationRepository:
                        context.read<AuthenticationRepository>(),
                    firestoreRepository: context.read<FirestoreRepository>(),),),
            BlocProvider<MapCubit>(
              create: (BuildContext context) => MapCubit(
                  googleRoutesService: context.read<GoogleRoutesService>(),),
            ),
            BlocProvider<OrderCubit>(
              create: (BuildContext context) => OrderCubit(
                  firestoreRepository: context.read<FirestoreRepository>(),
                  googlePlacesService: context.read<GooglePlacesService>(),
                  appSessionCubit: context.read<AppSessionCubit>(),),
            ),
            BlocProvider<LocationCubit>(
                create: (BuildContext context) => LocationCubit(
                      databaseRepository: context.read<DatabaseRepository>(),
                      appSessionCubit: context.read<AppSessionCubit>(),
                    ),),
            BlocProvider<ConnectivityCubit>(
                create: (BuildContext context) =>
                    ConnectivityCubit(connectivity: Connectivity()),),
            BlocProvider<AppInfoCubit>(
              create: (BuildContext context) => AppInfoCubit(),
            ),
          ],
          child: child,
        ),);
  }
}
