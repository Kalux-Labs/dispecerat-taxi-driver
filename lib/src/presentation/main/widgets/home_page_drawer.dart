import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSessionCubit, Driver?>(
        builder: (BuildContext context, Driver? driver) {
      return Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(driver?.name ?? ''),
                accountEmail: Text('Numar taxi: ${driver?.number ?? ''}')),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Setari'),
                onTap: () {
                  AppRouter.appNav.currentState!
                      .pushNamed(AppRoutes.settingsPage);
                }),
          ],
        ),
      );
    });
  }
}
