import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledColor;

  const AppButton({
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledColor ?? Colors.grey.withOpacity(.5),
        padding:const EdgeInsets.symmetric(horizontal: 50.0,vertical: 12.0),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
