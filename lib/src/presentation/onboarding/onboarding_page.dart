import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/business_logic/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/presentation/authentication/authentication_page.dart';
import 'package:driver/src/presentation/error/error_page.dart';
import 'package:driver/src/presentation/loading/loading_page.dart';
import 'package:driver/src/presentation/main/main_page.dart';
import 'package:driver/src/router/app_router.dart';
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
      if (context.mounted) {
        context.read<AuthenticationCubit>().checkUserStatus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
      print(state);
      return BlocBuilder<AppSessionCubit, Driver?>(
          builder: (BuildContext context, Driver? driver) {
        if (state is AuthError) {
          return const ErrorPage();
        } else if (state is AuthInitial ||
            state is AuthCodeAutoRetrievalTimeout ||
            state is AuthCodeSent) {
          return const AuthenticationPage();
        } else if (state is AuthSuccess) {
          context.read<AppSessionCubit>().initializeDriver(state.user);
          return const MainPage();
        }
        return const LoadingPage();
      });
    });
  }
}
