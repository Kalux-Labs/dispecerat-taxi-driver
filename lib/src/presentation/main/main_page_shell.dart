import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/presentation/main/main_page.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageShell extends StatefulWidget {
  const MainPageShell({super.key});

  @override
  State<MainPageShell> createState() => _MainPageShellState();
}

class _MainPageShellState extends State<MainPageShell>
    with WidgetsBindingObserver {
  final BuildContext _globalContext = AppRouter.appNav.currentContext!;

  @override
  void initState() {
    super.initState();
    if(_globalContext.mounted){
      _globalContext.read<AppSessionCubit>().updateDriverConnection(true);
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _handleAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }

  Future<void> _handleAppLifecycleState(AppLifecycleState state) async {
    if (_globalContext.mounted) {
      if (state == AppLifecycleState.resumed) {
        _globalContext.read<AppSessionCubit>().updateDriverConnection(true);
      } else {
        _globalContext.read<AppSessionCubit>().updateDriverConnection(false);
      }
    }
  }
}
