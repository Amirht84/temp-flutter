import 'package:flutter/material.dart';
import 'package:tennis_court/src/tennis_court_colors.dart';
import 'package:tennis_court/src/tennis_court_layout.dart';

class TennisCourtPainter extends CustomPainter {
  const TennisCourtPainter({required this.colors, required this.layout});

  final TennisCourtLayout layout;
  final TennisCourtColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final netShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final courtPaint = Paint()
      ..color = colors.court
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = colors.line
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final netPaint = Paint()
      ..color = colors.net
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final boundryPaint = Paint()
      ..color = colors.boundry
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    void drawLine(CourtLine line, Paint paint) {
      canvas.drawLine(line.start, line.end, paint);
    }

    canvas.drawRect(layout.courtRect, courtPaint);

    for (final line in layout.serviceLines) {
      drawLine(line, linePaint);
    }

    for (final line in layout.singlesSideLines) {
      drawLine(line, linePaint);
    }

    drawLine(layout.centerServiceLine, linePaint);

    canvas.drawRect(layout.courtRect, boundryPaint);

    drawLine(layout.net, netShadowPaint);
    drawLine(layout.net, netPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
