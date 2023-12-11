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
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: const Color(0xffF1EAFF),
        backgroundColor: const Color(0xffE5D4FF),
        foregroundColor: const Color(0xff5B0888),
        textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
          fontSize: 15,
        ),
      ),
      child: child,
    );
  }
}
