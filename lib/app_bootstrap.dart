import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/business_logic/cubits/app_theme_cubit.dart';
import 'package:driver/src/business_logic/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:driver/src/business_logic/cubits/location_cubit/location_cubit.dart';
import 'package:driver/src/business_logic/cubits/map_cubit/map_cubit.dart';
import 'package:driver/src/repositories/authentication_repository.dart';
import 'package:driver/src/repositories/database_repository.dart';
import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:driver/src/repositories/secure_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DatabaseRepository>(
              create: (context) => DatabaseRepository()),
          RepositoryProvider<FirestoreRepository>(
              create: (context) => FirestoreRepository()),
          RepositoryProvider<AuthenticationRepository>(
              create: (context) => AuthenticationRepository()),
          RepositoryProvider<SecureStorageRepository>(
              create: (context) => SecureStorageRepository())
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LocationCubit>(create: (context) => LocationCubit()),
            BlocProvider<AppThemeCubit>(create: (context) => AppThemeCubit()),
            BlocProvider<AppSessionCubit>(
                create: (context) => AppSessionCubit(
                    firestoreRepository: context.read<FirestoreRepository>())),
            BlocProvider<AuthenticationCubit>(
                create: (context) => AuthenticationCubit(
                    authenticationRepository:
                        context.read<AuthenticationRepository>())),
            BlocProvider<MapCubit>(
              create: (context) => MapCubit(),
            )
          ],
          child: child,
        ));
  }
}
