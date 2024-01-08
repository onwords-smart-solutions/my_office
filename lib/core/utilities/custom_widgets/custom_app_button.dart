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
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * .062,
      width: size.width * .9,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.deepPurple.shade300,
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
            fontSize: 20,
          ),
        ),
        child: child,
      ),
    );
  }
}
