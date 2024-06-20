import 'package:flutter/material.dart';

class CircledIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  const CircledIconButton(
      {super.key, required this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Icon(iconData),
        style: ElevatedButton.styleFrom(shape: CircleBorder()));
  }
}
