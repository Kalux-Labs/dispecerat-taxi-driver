// ignore_for_file: unused_import

import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/business_logic/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:driver/src/business_logic/cubits/connectivity_cubit/connectivity_cubit.dart';
import 'package:driver/src/business_logic/cubits/order_cubit/order_cubit.dart';
import 'package:driver/src/presentation/authentication/authentication_page.dart';
import 'package:driver/src/presentation/error/error_page.dart';
import 'package:driver/src/presentation/error/no_internet_page.dart';
import 'package:driver/src/presentation/loading/loading_page.dart';
import 'package:driver/src/presentation/main/main_page.dart';
import 'package:driver/src/presentation/main/main_page_shell.dart';
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
            .initializeDriverByPhoneNumber(state.user)
            .then((value) {
          context.read<OrderCubit>().listenForDriverChanges();
        });
      }
    }, builder: (BuildContext context, AuthenticationState state) {
      return BlocConsumer<ConnectivityCubit, ConnectivityState>(
        listener: (BuildContext context, ConnectivityState internetState) {
          if (state is AuthSuccess) {
            if (internetState is ConnectivityDisconnected) {
              context.read<AppSessionCubit>().updateDriverConnection(false);
            } else {
              context.read<AppSessionCubit>().updateDriverConnection(true);
            }
          }
        },
        builder: (BuildContext context, ConnectivityState internetState) {
          if (internetState is ConnectivityDisconnected) {
            return const NoInternetPage();
          } else if (state is AuthError) {
            return ErrorPage(
              title: "Codul este invalid",
              callback: () {
                // AppRoute
                context.read<AuthenticationCubit>().resetAuthentication();
              },
              callbackText: "Inapoi",
              // description: "",
            );
          } else if (state is AuthPhoneNumberNotFound) {
            return ErrorPage(
              title: "Numarul nu este inregistrat",
              callback: () {
                context.read<AuthenticationCubit>().resetAuthentication();
              },
              callbackText: "Inapoi",
            );
          } else if (state is AuthInitial ||
              state is AuthCodeAutoRetrievalTimeout ||
              state is AuthCodeSent) {
            return const AuthenticationPage();
          } else if (state is AuthSuccess) {
            return const MainPageShell();
          }
          return const LoadingPage();
        },
      );
    });
  }
}
