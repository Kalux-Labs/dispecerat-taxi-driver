import 'package:driver/src/presentation/main/widgets/home_page_drawer.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:driver/src/utils/widgets/circled_icon_button.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppRouter.homePageScaffoldState,
      drawer: const HomePageDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                child: CircledIconButton(
              onPressed: _handleDrawer,
              iconData: Icons.menu,
            )),
          ],
        ),
      ),
    );
  }

  void _handleDrawer() {
    if (AppRouter.homePageScaffoldState.currentState!.isDrawerOpen) {
      AppRouter.homePageScaffoldState.currentState!.openEndDrawer();
    } else {
      AppRouter.homePageScaffoldState.currentState!.openDrawer();
    }
  }
}
