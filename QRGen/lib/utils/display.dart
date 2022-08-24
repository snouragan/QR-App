import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  static String parseDate(DateTime start, DateTime end) {
    final sMonth = start.month < 10 ? '0${start.month}' : start.month;
    final sDay = start.day < 10 ? '0${start.day}' : start.day;
    final sHour = start.hour;
    final sMinute = start.minute < 10 ? '0${start.minute}' : start.minute;

    final eMonth = end.month < 10 ? '0${end.month}' : end.month;
    final eDay = end.day < 10 ? '0${end.day}' : end.day;
    final eHour = end.hour;
    final eMinute = end.minute < 10 ? '0${end.minute}' : end.minute;

    final monthString = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][start.month];

    if (sMonth == eMonth && sDay == eDay) {
      if (start.month == DateTime.now().month &&
          start.day == DateTime.now().day) {
        return 'Today, $sHour:$sMinute - $eHour:$eMinute';
      }
      return '$monthString ${start.day}${start.day % 10 == 1 ? 'st' : start.day % 10 == 2 ? 'nd' : start.day % 10 == 3 ? 'rd' : 'th'}, $sHour:$sMinute - $eHour:$eMinute';
    }

    return '$sHour:$sMinute, $sDay/$sMonth - $eHour:$eMinute, $eDay/$eMonth';
  }
}
