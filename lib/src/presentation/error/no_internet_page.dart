// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Nu exista conexiune la internet',
                style: Theme.of(context).textTheme.bodyLarge,),
            Text('Va rugam sa va reconectat la internet'),
          ],
        ),
      ),
    );
  }
}
