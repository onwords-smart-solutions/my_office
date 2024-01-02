import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showErrorSnackbar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0.0,
        showCloseIcon: true,
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, ),
        ),
      ),
    );
  }

  static void showSuccessSnackbar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0.0,
        showCloseIcon: true,
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, ),
        ),
      ),
    );
  }
}