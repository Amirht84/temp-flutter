import 'package:flutter/material.dart';

class TennisCourtColors {
  const TennisCourtColors({
    this.court = const Color(0xFFAEB984),
    this.line = const Color(0x80FFFFFF),
    this.net = const Color(0xFFFFFFFF),
    this.boundry = const Color(0x80FFFFFF),
    this.shadow = const Color(0x33000000),
    this.dash = const Color(0x4BFFFFFF),
    this.selected = const Color(0x333B82F6),
  });

  final Color court;
  final Color line;
  final Color net;
  final Color boundry;
  final Color shadow;
  final Color dash;
  final Color selected;
}
