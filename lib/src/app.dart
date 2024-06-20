import 'package:driver/src/business_logic/cubits/app_theme_cubit.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, ThemeData>(builder: (context, theme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initialRoute,
        navigatorKey: AppRouter.appNav,
        onGenerateRoute: AppRouter.generateAppNavigatorRoutes,
        theme: theme,
        scaffoldMessengerKey: AppRouter.scaffoldMessengerState,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
      );
    });
  }
}
