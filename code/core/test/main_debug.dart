// ============================================================
// FILE: test/main_debug.dart
// A separate entry point so you can test real BLE hardware
// without touching your real main.dart or your friend's UI work.
//
// Run on a physical phone (BLE doesn't work in the simulator/
// desktop debugger — you need real Bluetooth hardware):
//   flutter run -t test/main_debug.dart
// ============================================================

import 'package:flutter/material.dart';

import 'debug_robot_screen.dart';

void main() {
  runApp(const DebugApp());
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Robot BLE Debug',
      home: DebugRobotScreen(),
    );
  }
}
