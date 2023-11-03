import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Widget? child;
  final Color? textColor;

  const AppButton({
    required this.onPressed,
    this.backgroundColor,
    required this.child,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        textStyle: TextStyle(
          color: textColor,
        ),
      ),
      child: child,
    );
  }
}
