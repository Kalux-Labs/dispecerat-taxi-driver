import 'package:driver/src/presentation/main/main_page.dart';
import 'package:flutter/material.dart';

class MainPageShell extends StatefulWidget {
  const MainPageShell({super.key});

  @override
  State<MainPageShell> createState() => _MainPageShellState();
}

class _MainPageShellState extends State<MainPageShell>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}
