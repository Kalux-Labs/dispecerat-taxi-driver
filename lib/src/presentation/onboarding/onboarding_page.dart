import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/business_logic/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/presentation/authentication/authentication_page.dart';
import 'package:driver/src/presentation/error/error_page.dart';
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
      if (context.mounted) {
        context.read<AuthenticationCubit>().checkUserStatus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (BuildContext context, AuthenticationState state) {
      if (state is AuthSuccess) {
        context
            .read<AppSessionCubit>()
            .initializeDriverByPhoneNumber(state.user);
      }
    }, builder: (BuildContext context, AuthenticationState state) {
      if (state is AuthError) {
        return ErrorPage(
          title: "Codul este invalid",
          callback: () {
            // AppRoute
            context.read<AuthenticationCubit>().resetAuthentication();
          },
          callbackText: "Inapoi",
          // description: "",
        );
      } else if (state is AuthInitial ||
          state is AuthCodeAutoRetrievalTimeout ||
          state is AuthCodeSent) {
        return const AuthenticationPage();
      } else if (state is AuthSuccess) {
        return const MainPage();
      }
      return const LoadingPage();
    });
  }
}
