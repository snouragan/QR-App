import 'package:flutter/material.dart';
import 'package:qrgen/views/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRGen',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        )
      ),
      home: const MainView(),
    );
  }
}