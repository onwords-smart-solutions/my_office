import 'package:flutter/material.dart';

class CustomAlerts {
  static void showAlertDialog(
      {required BuildContext context,
      required String title,
      required String content,
      required Widget actionButton,
      Widget? cancelButton,
      required bool barrierDismissible}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog.adaptive(
              title: Text(title),
              content: Text(content),
              actions: [
                if (cancelButton != null) cancelButton,
                actionButton,
              ],
            ),
          );
        });
  }
}
