import 'package:flutter/material.dart';

class Values {
  static const String serverAddress = 'http://192.168.0.97:3000';

  static const darkPrimaryColor = Colors.deepOrange;

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      background: Colors.black87,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(
        color: darkPrimaryColor,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.white24,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    cardTheme: const CardTheme(
      color: Color(0xff242424),
      surfaceTintColor: Color(0xff3e3e3e),
    ),
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 28.0,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
      ),
    ),
    dividerColor: Colors.transparent,
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: darkPrimaryColor,
      collapsedIconColor: darkPrimaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      enableFeedback: true,
      foregroundColor: Colors.white,
      backgroundColor: darkPrimaryColor,
    ),
    iconTheme: const IconThemeData(
      color: darkPrimaryColor,
      size: 30,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: darkPrimaryColor,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith((states) => darkPrimaryColor),
    ),
    snackBarTheme: const SnackBarThemeData(
      actionTextColor: darkPrimaryColor,
      backgroundColor: Color(0xff242424),
      disabledActionTextColor: Colors.white54,
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 34.0,
        fontWeight: FontWeight.w400,
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 44.0,
        fontWeight: FontWeight.w400,
      ),
      subtitle1: TextStyle(
        color: Colors.white54,
        fontSize: 16.0,
      ),
      button: TextStyle(
        color: darkPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static const lightPrimaryColor = Colors.orange;

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: lightPrimaryColor,
      background: Colors.white70,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(
        color: lightPrimaryColor,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.black26,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    cardTheme: const CardTheme(
      color: Color(0xffffffff),
      surfaceTintColor: Color(0xfff1f1f1),
    ),
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 28.0,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 24.0,
      ),
    ),
    dividerColor: Colors.transparent,
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: lightPrimaryColor,
      collapsedIconColor: lightPrimaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      enableFeedback: true,
      foregroundColor: Colors.black,
      backgroundColor: lightPrimaryColor,
    ),
    iconTheme: const IconThemeData(
      color: lightPrimaryColor,
      size: 30,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: lightPrimaryColor,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith((states) => lightPrimaryColor),
    ),
    snackBarTheme: const SnackBarThemeData(
      actionTextColor: lightPrimaryColor,
      backgroundColor: Color(0xffffffff),
      disabledActionTextColor: Colors.black54,
      contentTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 34.0,
        fontWeight: FontWeight.w400,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontSize: 24.0,
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 44.0,
        fontWeight: FontWeight.w400,
      ),
      subtitle1: TextStyle(
        color: Colors.black54,
        fontSize: 16.0,
      ),
      button: TextStyle(
        color: lightPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
