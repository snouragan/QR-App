import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qrgen/utils/preferences.dart';
import 'package:qrgen/values.dart';
import 'package:qrgen/views/main_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QrApp());
}

class QrApp extends StatefulWidget {
  const QrApp({Key? key}) : super(key: key);

  @override
  State<QrApp> createState() => _QrAppState();
}

class _QrAppState extends State<QrApp> {

  late ThemeData _theme;

  void setTheme(int index) {
    setState(() {
      if (index == 2) {
        final brightness = SchedulerBinding.instance.window.platformBrightness;
        _theme = brightness == Brightness.dark ? Values.darkTheme : Values.lightTheme;
      } else {
        _theme = [Values.lightTheme, Values.darkTheme][index];
      }
    });
  }

  Future<void> initTheme() async {
    final theme = await Preferences.getTheme();
    setTheme(theme);
  }

  @override
  void initState() {
    super.initState();
    initTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRGen',
      theme: _theme,
      home: MainView(themeCallback: setTheme),
    );  }
}

