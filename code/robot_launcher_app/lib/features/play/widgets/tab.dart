import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:robot_launcher_app/shared/constants/themes.dart';

const double innerTabWidth = 200;
const double outerTabWidth = 30;
const double tabPadding = 5;
const double tabStrokeWidth = 1;

enum Position { left, right }

class AppTab extends StatelessWidget {
  const AppTab({
    super.key,
    required this.position,
    this.isSelected = false,
    required this.onPressed,
    this.icon,
    this.child,
  });
  final Position position;
  final bool isSelected;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: tabPadding),
      child: SizedBox(
        width: isSelected ? innerTabWidth + outerTabWidth : outerTabWidth,
        child: Transform.flip(
          flipX: position == .right,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  painter: _TabPainter(
                    strokeWidth: tabStrokeWidth,
                    borderColor: Palet.border,
                    isOpen: isSelected,
                    color: Palet.cards,
                    shadowColor: Palet.shadow,
                    shadowOffset: Offset(2, 3),
                    blurRadius: 4,
                    innerWidth: innerTabWidth,
                    outerWidth: outerTabWidth,
                    curveFlex: 1,
                    capsuleFlex: 2,
                    firstCurveFactor: 0.1,
                    secondCurveFactor: 0.1,
                    curveAngle: 80,
                    curveHeight: 80
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 0,
                bottom: 0,
                child: Transform.flip(
                  flipX: position == .right,
                  child: GestureDetector(
                    onTap: onPressed,
                    child: SizedBox
                  (
                    height: 20,
                    width: 20,
                    child: Icon(size: 20, icon,
                  ),
                ),
                )
                ),
              ),
              Positioned(
                right: outerTabWidth,
                top: 0,
                bottom: 0,
                left: 0,
                child: isSelected ? Transform.flip(
                  flipX: position == .right,
                  child: child ?? Container()) : Container()
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TabPainter extends CustomPainter {
  const _TabPainter({
    required this.color,
    required this.shadowColor,
    required this.shadowOffset,
    required this.blurRadius,
    required this.isOpen,
    required this.borderColor,
    required this.strokeWidth,
    required this.capsuleFlex,
    required this.curveFlex,
    required this.innerWidth,
    required this.outerWidth,
    required this.curveHeight,
    required this.firstCurveFactor,
    required this.secondCurveFactor,
    required this.curveAngle,
  });

  final Color borderColor;

  final Color color;

  final Color shadowColor;

  final Offset shadowOffset;

  final double blurRadius;

  final bool isOpen;

  final double strokeWidth;

  final double capsuleFlex;

  final double curveFlex;

  final double innerWidth;

  final double outerWidth;

  final double curveHeight;

  final double firstCurveFactor;

  final double secondCurveFactor;

  final double curveAngle;

  double get _capsuleWidth {
    return capsuleFlex * outerTabWidth / (capsuleFlex + curveFlex);
  }
  double get _curveWidth {
    return curveFlex * outerTabWidth / (capsuleFlex + curveFlex);
  }
  @override
  void paint(Canvas canvas, Size size) {
    final path = _TabPath(
      capsuleWidth: _capsuleWidth,
      curveWidth: _curveWidth,
      rectWidth: isOpen ? innerTabWidth : 0,
      height: size.height,
      curveHeight: curveHeight,
      firstCurveFactor: firstCurveFactor,
      secondCurveFactor: secondCurveFactor,
      curveAngle: curveAngle,
    ).path;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    canvas.save();

    canvas.translate(shadowOffset.dx, shadowOffset.dy);

    canvas.drawPath(path, shadowPaint);

    canvas.restore();

    canvas.drawPath(path, paint);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _TabPainter oldDelegate) {
    return color != oldDelegate.color ||
        shadowColor != oldDelegate.shadowColor ||
        shadowOffset != oldDelegate.shadowOffset ||
        blurRadius != oldDelegate.blurRadius;
  }
}

class _TabPath {
  const _TabPath({
    required this.rectWidth,
    required this.capsuleWidth,
    required this.height,
    required this.curveHeight,
    required this.firstCurveFactor,
    required this.secondCurveFactor,
    required this.curveAngle,
    required this.curveWidth,
  });
  final double rectWidth;
  final double capsuleWidth;
  final double height;
  final double curveHeight;
  final double curveWidth;
  final double firstCurveFactor;
  final double secondCurveFactor;
  final double curveAngle;

  double _degreeToRadian(double degree) {
    return degree * math.pi / 180;
  }

  Offset _pointAtAngle({
    required Offset start,
    required double angle,
    required double length,
  }) {
    final radian = _degreeToRadian(angle);

    return Offset(
      start.dx + length * math.cos(radian),
      start.dy + length * math.sin(radian),
    );
  }

  Offset get point1 {
    return Offset(rectWidth + capsuleWidth, height / 2 - curveHeight / 2);
  }

  Offset get point2 {
    return Offset(
      rectWidth + capsuleWidth + curveWidth / 2,
      height / 2 - curveHeight / 4,
    );
  }

  Offset get point3 {
    return Offset(rectWidth + capsuleWidth + curveWidth, height / 2);
  }

  Offset get point4 {
    return Offset(
      rectWidth + capsuleWidth + curveWidth / 2,
      height / 2 + curveHeight / 4,
    );
  }

  Offset get point5 {
    return Offset(rectWidth + capsuleWidth, height / 2 + curveHeight / 2);
  }

  double get _verticalControlLength {
    return firstCurveFactor * curveHeight;
  }

  double get _angularControlLength {
    return secondCurveFactor * curveWidth;
  }

  Path get path {
    final firstControlPoint1 = _pointAtAngle(
      start: point1,
      angle: 90,
      length: _verticalControlLength,
    );
    final secondControlPoint1 = _pointAtAngle(
      start: point2,
      angle: 180 + curveAngle,
      length: _angularControlLength,
    );
    final firstControlPoint2 = _pointAtAngle(
      start: point2,
      angle: curveAngle,
      length: _angularControlLength,
    );
    final secondControlPoint2 = _pointAtAngle(
      start: point3,
      angle: -90,
      length: _verticalControlLength,
    );
    final firstControlPoint3 = _pointAtAngle(
      start: point3,
      angle: 90,
      length: _verticalControlLength,
    );
    final secondControlPoint3 = _pointAtAngle(
      start: point4,
      angle: -curveAngle,
      length: _angularControlLength,
    );
    final firstControlPoint4 = _pointAtAngle(
      start: point4,
      angle: 180 - curveAngle,
      length: _angularControlLength,
    );
    final secondControlPoint4 = _pointAtAngle(
      start: point5,
      angle: -90,
      length: _verticalControlLength,
    );
    return Path()
      ..moveTo(0, 0)
      ..lineTo(rectWidth, 0)
      ..arcToPoint(
        Offset(rectWidth + capsuleWidth, capsuleWidth),
        radius: Radius.circular(capsuleWidth),
      )
      ..lineTo(rectWidth + capsuleWidth, height / 2 - curveHeight / 2)
      ..cubicTo(
        firstControlPoint1.dx,
        firstControlPoint1.dy,
        secondControlPoint1.dx,
        secondControlPoint1.dy,
        point2.dx,
        point2.dy,
      )
      ..cubicTo(
        firstControlPoint2.dx,
        firstControlPoint2.dy,
        secondControlPoint2.dx,
        secondControlPoint2.dy,
        point3.dx,
        point3.dy,
      )
      ..cubicTo(
        firstControlPoint3.dx,
        firstControlPoint3.dy,
        secondControlPoint3.dx,
        secondControlPoint3.dy,
        point4.dx,
        point4.dy,
      )
      ..cubicTo(
        firstControlPoint4.dx,
        firstControlPoint4.dy,
        secondControlPoint4.dx,
        secondControlPoint4.dy,
        point5.dx,
        point5.dy,
      )
      ..lineTo(rectWidth + capsuleWidth, height - capsuleWidth)
      ..arcToPoint(
        Offset(rectWidth, height),
        radius: Radius.circular(capsuleWidth),
      )
      ..lineTo(0, height)
      ..lineTo(0, 0);
  }
}
