import 'package:flutter/material.dart';
import 'shared/constants/themes.dart';
import 'features/ble_scan/ble_scan_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Palet.backGround,
        colorScheme: ColorScheme.fromSeed(seedColor: Palet.primaryAccent),
      ),
      home: const BleScanPage(),
    );
  }
}
