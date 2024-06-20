import 'package:driver/src/presentation/main/main_page.dart';
import 'package:driver/src/presentation/onboarding/onboarding_page.dart';
import 'package:driver/src/presentation/settings/settings_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  static const String initialRoute = '/';
  static const String onboardingPage = '/onboarding';
  static const String mainPage = '/main';
  static const String settingsPage = '/settings';
}

class AppRouter {
  static final scaffoldMessengerState = GlobalKey<ScaffoldMessengerState>();

  static final homePageScaffoldState = GlobalKey<ScaffoldState>();

  static final appNav = GlobalKey<NavigatorState>();

  static Route<dynamic> generateAppNavigatorRoutes(RouteSettings settings) {
    final Object? args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.initialRoute:
        return _goToPage(const OnboardingPage(), settings);
      case AppRoutes.onboardingPage:
        return _goToPage(const OnboardingPage(), settings);
      case AppRoutes.mainPage:
        return _goToPage(const MainPage(), settings);
      case AppRoutes.settingsPage:
        return _goToPage(const SettingsPage(), settings);
      default:
        //TODO: replace with Error screen
        return _goToPage(const OnboardingPage(), settings);
    }
  }

  static MaterialPageRoute<Widget> _goToPage(
          Widget page, RouteSettings settings) =>
      MaterialPageRoute<Widget>(builder: (_) => page, settings: settings);
}
