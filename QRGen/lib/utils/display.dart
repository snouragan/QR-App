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

  static String parseDate(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;
    final hour = date.hour;
    final minute = date.minute < 10 ? '0${date.minute}' : date.minute;

    return '$hour:$minute';
  }
}
