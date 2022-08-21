import 'package:flutter/material.dart';

class Display {
  static void showDismissibleSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      content: Text(content),
      action: SnackBarAction(
        label: 'DISMISS',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
