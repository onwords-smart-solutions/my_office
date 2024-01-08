import 'package:flutter/material.dart';

class CustomAlerts {
  static void showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Widget actionButton,
    Widget? cancelButton,
    required bool barrierDismissible,
  }) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            surfaceTintColor: Colors.transparent,
            title: Text(
                title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            content: Text(
                content,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
            actions: [
              if (cancelButton != null) cancelButton,
              actionButton,
            ],
          ),
        );
      },
    );
  }
}
