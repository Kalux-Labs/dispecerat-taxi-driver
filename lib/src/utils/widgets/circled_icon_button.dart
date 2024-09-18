import 'package:flutter/material.dart';

class CircledIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  const CircledIconButton(
      {required this.onPressed, required this.iconData, super.key,});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(shape: const CircleBorder()),
        child: Icon(iconData),);
  }
}
