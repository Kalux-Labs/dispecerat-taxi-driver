import 'package:flutter/material.dart';

class FullWidthFilledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const FullWidthFilledButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: MediaQuery.of(context).size.width,
      child: FilledButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
