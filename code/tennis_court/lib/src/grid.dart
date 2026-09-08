import 'package:flutter/material.dart';

const zoneColor = Color(0x333B82F6);

class Grid extends StatelessWidget {
  const Grid({
    super.key,
    this.cols,
    this.rows,
    this.widthFlex,
    this.heightFlex,
    required this.rect,
    required this.idMap,
    required this.onToggle,
    this.selectedId,
  });

  final int? cols;
  final int? rows;
  final Rect rect;
  final List<int>? widthFlex;
  final List<int>? heightFlex;
  final List<List<int>> idMap;
  final int? selectedId;
  final ValueChanged<int?> onToggle;

  void _validate() {
    final hasRows = rows != null;
    final hasHeightFlex = heightFlex != null;

    if (hasRows == hasHeightFlex) {
      throw ArgumentError(
        'Exactly one of "rows" or "heightFlex" must be provided.',
      );
    }

    final hasCols = cols != null;
    final hasWidthFlex = widthFlex != null;

    if (hasCols == hasWidthFlex) {
      throw ArgumentError(
        'Exactly one of "cols" or "widthFlex" must be provided.',
      );
    }

    if (rows != null && rows! <= 0) {
      throw ArgumentError.value(rows, 'rows', 'Must be greater than zero.');
    }

    if (cols != null && cols! <= 0) {
      throw ArgumentError.value(cols, 'cols', 'Must be greater than zero.');
    }

    if (heightFlex != null) {
      if (heightFlex!.isEmpty) {
        throw ArgumentError.value(
          heightFlex,
          'heightFlex',
          'Must not be empty.',
        );
      }

      if (heightFlex!.any((value) => value <= 0)) {
        throw ArgumentError.value(
          heightFlex,
          'heightFlex',
          'All values must be greater than zero.',
        );
      }
    }

    if (widthFlex != null) {
      if (widthFlex!.isEmpty) {
        throw ArgumentError.value(widthFlex, 'widthFlex', 'Must not be empty.');
      }

      if (widthFlex!.any((value) => value <= 0)) {
        throw ArgumentError.value(
          widthFlex,
          'widthFlex',
          'All values must be greater than zero.',
        );
      }
    }
  }

  int get _colsCount {
    return widthFlex?.length ?? cols!;
  }

  int get _rowsCount {
    return heightFlex?.length ?? rows!;
  }

  @override
  Widget build(BuildContext context) {
    _validate();

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(rect.width, rect.height),
            painter: _DashPainter(
              dashColor: Colors.white.withAlpha(75),
              rows: rows,
              cols: cols,
              heightFlex: heightFlex,
              widthFlex: widthFlex,
            ),
          ),

          Column(
            children: [
              for (int i = 0; i < _rowsCount; i++)
                Expanded(
                  flex: heightFlex?[i] ?? 1,
                  child: Row(
                    children: [
                      for (int j = 0; j < _colsCount; j++)
                        Expanded(
                          // اینجا باید j باشد، نه i
                          flex: widthFlex?[j] ?? 1,
                          child: _CourtZone(
                            isSelected: idMap[i][j] == selectedId,
                            onPressed: () {
                              final id = idMap[i][j];

                              onToggle(id == selectedId ? null : id);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter({
    required this.dashColor,
    this.rows,
    this.cols,
    this.heightFlex,
    this.widthFlex,
  });

  final Color dashColor;
  final int? rows;
  final int? cols;
  final List<int>? widthFlex;
  final List<int>? heightFlex;

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashLength = 8.0;
    const gapLength = 6.0;

    final direction = end - start;
    final length = direction.distance;

    if (length == 0) return;

    final unit = direction / length;

    double distance = 0;

    while (distance < length) {
      final dashStart = start + unit * distance;

      final dashEndDistance = (distance + dashLength)
          .clamp(0.0, length)
          .toDouble();

      final dashEnd = start + unit * dashEndDistance;

      canvas.drawLine(dashStart, dashEnd, paint);

      distance += dashLength + gapLength;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = false;

    final heightSum =
        heightFlex?.fold<int>(0, (sum, value) => sum + value) ?? rows!;

    final widthSum =
        widthFlex?.fold<int>(0, (sum, value) => sum + value) ?? cols!;

    final heightUnit = size.height / heightSum;
    final widthUnit = size.width / widthSum;

    // Vertical lines
    final colsCount = widthFlex?.length ?? cols!;

    for (int i = 1; i < colsCount; i++) {
      final multiple =
          widthFlex?.sublist(0, i).fold<int>(0, (sum, value) => sum + value) ??
          i;

      final x = (widthUnit * multiple).roundToDouble();

      _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Horizontal lines
    final rowsCount = heightFlex?.length ?? rows!;

    for (int i = 1; i < rowsCount; i++) {
      final multiple =
          heightFlex?.sublist(0, i).fold<int>(0, (sum, value) => sum + value) ??
          i;

      final y = (heightUnit * multiple).roundToDouble();

      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) {
    return oldDelegate.dashColor != dashColor ||
        oldDelegate.rows != rows ||
        oldDelegate.cols != cols ||
        oldDelegate.widthFlex != widthFlex ||
        oldDelegate.heightFlex != heightFlex;
  }
}

class _CourtZone extends StatelessWidget {
  const _CourtZone({this.onPressed, this.isSelected = false});
  final VoidCallback? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed?.call();
      },
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        backgroundColor: WidgetStatePropertyAll(
          isSelected ? zoneColor : Colors.transparent,
        ),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return zoneColor;
          }
          return Colors.transparent;
        }),
      ),
      child: Container(),
    );
  }
}
