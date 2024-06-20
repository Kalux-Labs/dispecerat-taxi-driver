import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const FullWidthButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
