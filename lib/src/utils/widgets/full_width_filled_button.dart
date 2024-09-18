import 'package:flutter/material.dart';

class FullWidthFilledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const FullWidthFilledButton({required this.onPressed, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: FilledButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
