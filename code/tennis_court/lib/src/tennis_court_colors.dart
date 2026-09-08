import 'package:flutter/material.dart';

class TennisCourtColors {
  const TennisCourtColors({
    this.court = Colors.green,
    this.line = const Color(0x80FFFFFF),
    this.net = const Color(0xFFFFFFFF),
    this.boundry = const Color(0xFF000000),
    this.shadow = const Color(0x33000000),
  });

  final Color court;
  final Color line;
  final Color net;
  final Color boundry;
  final Color shadow;
}
