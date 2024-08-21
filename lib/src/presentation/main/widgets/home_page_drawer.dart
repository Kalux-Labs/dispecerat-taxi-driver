import 'package:driver/src/business_logic/cubits/app_info_cubit.dart';
import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/business_logic/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:driver/src/models/driver.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSessionCubit, Driver?>(
        builder: (BuildContext context, Driver? driver) {
      return BlocBuilder<AppInfoCubit, PackageInfo?>(
        builder: (BuildContext context, PackageInfo? packageInfo) {
          return Drawer(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                    accountName: Text(driver?.name ?? ''),
                    accountEmail: Text('Numar taxi: ${driver?.number ?? ''}')),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Disponibil'),
                      Switch(
                        value: driver!.online,
                        onChanged: (value) {
                          context
                              .read<AppSessionCubit>()
                              .updateDriverConnection(value);
                        },
                      )
                    ],
                  ),
                ),
                ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Setari'),
                    onTap: () {
                      AppRouter.appNav.currentState!
                          .pushNamed(AppRoutes.settingsPage);
                    }),
                const Spacer(),
                ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Delogare'),
                    onTap: () {
                      context.read<AuthenticationCubit>().signOut();
                    }),
                ListTile(
                  leading: Text(
                      "Versiune: ${packageInfo?.version} ${packageInfo?.buildNumber}"),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
