import 'package:flutter/material.dart';
import 'package:tennis_court/src/grid.dart';
import 'tennis_court_colors.dart';
import 'package:tennis_court/src/tennis_court_layout.dart';
import 'tennis_court_painter.dart';

class TennisCourt extends StatefulWidget {
  const TennisCourt({super.key});
  @override
  State<StatefulWidget> createState() => _TennisCourtState();
}

class _TennisCourtState extends State<TennisCourt> {
  late bool _isSelected;
  @override
  void initState() {
    _isSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      width: 400,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = TennisCourtLayout(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
          return Stack(
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: TennisCourtPainter(
                  colors: TennisCourtColors(
                    court: Colors.green,
                    line: Colors.white,
                    net: Colors.grey,
                    boundry: Colors.black,
                    shadow: Colors.black.withValues(alpha: 0.2),
                  ),
                  layout: layout,
                ),
              ),
              _GridPack(
                layout: layout,
              )
            ],
          );
        },
      ),
    );
  }
}
class _GridPack extends StatefulWidget {
  const _GridPack({
    required this.layout,
  });
  final TennisCourtLayout layout;
  @override
  State<StatefulWidget> createState() => _GridPackState();
}
class _GridPackState extends State<_GridPack> {
  int? _selectedId;
  void _onToggle(int? value) => setState(() => _selectedId = value);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
              Grid(
                cols: 4,
                rows: 2,
                rect: widget.layout.noMansLand,
                idMap: [
                  [2, 3, 4, 5],
                  [8, 9, 10, 11],
                ],
                onToggle: _onToggle,
                selectedId: _selectedId,
              ),
              Grid(
                cols: 1,
                heightFlex: widget.layout.doublesHeightFlexList,
                rect: widget.layout.rightDoubles,
                idMap: [
                  [6],
                  [12],
                  [18],
                ],
                onToggle: _onToggle,
                selectedId: _selectedId,
              ),
              Grid(
                cols: 1,
                heightFlex: widget.layout.doublesHeightFlexList,
                rect: widget.layout.leftDoubles,
                idMap: [
                  [1],
                  [7],
                  [13]
                ],
                onToggle: _onToggle,
                selectedId: _selectedId,
              ),
              Grid(
                cols: 2,
                rows: 1,
                rect: widget.layout.leftServiceCourt,
                idMap: [
                  [14, 15]
                ],
                onToggle: _onToggle,
                selectedId: _selectedId,
              ),
              Grid(
                cols: 2,
                rows: 1,
                rect: widget.layout.rightServiceCourt,
                idMap: [
                  [16, 17]
                ],
                onToggle: _onToggle,
                selectedId: _selectedId,
              ),
      ]
    );
  }
}
