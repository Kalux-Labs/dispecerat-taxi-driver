import 'package:driver/src/presentation/main/main_page.dart';
import 'package:driver/src/presentation/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  static const String initialRoute = '/';
  static const String onboardingPage = '/onboardingPage';
  static const String mainPage = '/mainPage';
}

class AppRouter {
  static final GlobalKey<ScaffoldMessengerState> homeScaffoldMessenger =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<NavigatorState> appNav = GlobalKey();

  static Route<dynamic> generateAppNavigatorRoutes(RouteSettings settings) {
    final Object? args = settings.arguments;

    switch(settings.name) {
      case AppRoutes.initialRoute:
        return _goToPage(const OnboardingPage(), settings);
      case AppRoutes.onboardingPage:
        return _goToPage(const OnboardingPage(), settings);
      case AppRoutes.mainPage:
        return _goToPage(const MainPage(), settings);
      default:
        //TODO: replace with Error screen
        return _goToPage(const OnboardingPage(), settings);
    }
  }

  static MaterialPageRoute<Widget> _goToPage(Widget page, RouteSettings settings) => MaterialPageRoute<Widget>(builder: (_) => page, settings: settings);
}
