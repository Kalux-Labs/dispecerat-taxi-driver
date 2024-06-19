import 'package:driver/src/business_logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:driver/src/presentation/authentication/authentication_page.dart';
import 'package:driver/src/presentation/loading/loading_page.dart';
import 'package:driver/src/presentation/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if(context.mounted) {
        context.read<AuthenticationBloc>().add(GetLoginStatus());
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState authenticationState) {
        if(authenticationState.authenticationError == AuthenticationError.atLogin) {
          // go to error page
        }
        if(authenticationState.authenticationError == AuthenticationError.atFetchingLoginStatus){
          // go to error page
        }
        if(authenticationState.authenticationStatus == AuthenticationStatus.unauthenticated) {
          return const AuthenticationPage();
        }
        if(authenticationState.authenticationStatus == AuthenticationStatus.authenticated || authenticationState.isLoggedIn) {
          return const MainPage();
        }
        return const LoadingPage();
      }
    );
  }
}
