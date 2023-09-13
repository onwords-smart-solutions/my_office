import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomButton({Key? key, required this.onPressed, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
