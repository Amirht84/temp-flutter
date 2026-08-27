import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

class JoystickPainter extends CustomPainter {
  const JoystickPainter({required this.appearance});

  final JoystickAppearance appearance;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.shortestSide / 2;

    final mainRadius = radius * 0.8;
    final innerRadius = radius * 0.25;
    final innerBorderRadius = radius * 0.5;

    // Main circle
    canvas.drawCircle(
      center,
      mainRadius,
      Paint()
        ..color = appearance.surfaceColor
        ..style = PaintingStyle.fill,
    );

    // Main border
    canvas.drawCircle(
      center,
      mainRadius,
      Paint()
        ..color = appearance.mainBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = appearance.mainBorderWidth,
    );

    // Inner border
    canvas.drawCircle(
      center,
      innerBorderRadius,
      Paint()
        ..color = appearance.innerBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = appearance.innerBorderWidth,
    );

    // Inner circle
    canvas.drawCircle(
      center,
      innerRadius,
      Paint()
        ..color = appearance.innerSurfaceColor
        ..style = PaintingStyle.fill,
    );

    // Inner shadow
    canvas.drawCircle(
      center,
      innerRadius,
      Paint()
        ..color = Palet.shadow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 5),
    );
  }

  @override
  bool shouldRepaint(covariant JoystickPainter oldDelegate) {
    return oldDelegate.appearance != appearance;
  }
}

class JoystickAppearance {
  const JoystickAppearance({
    this.innerSurfaceColor = Palet.disabled,
    this.surfaceColor = Colors.white,
    this.mainBorderColor = const Color(0xFFE0E0E0),
    this.innerBorderColor = const Color(0xFFE0E0E0),
    this.mainBorderWidth = 2,
    this.innerBorderWidth = 1,
  });

  final Color innerSurfaceColor;
  final Color surfaceColor;
  final Color mainBorderColor;
  final Color innerBorderColor;

  final double mainBorderWidth;
  final double innerBorderWidth;
}
