import 'package:flutter/material.dart';
import 'package:tennis_court/src/grid.dart';
import 'tennis_court_colors.dart';
import 'package:tennis_court/src/tennis_court_layout.dart';
import 'tennis_court_painter.dart';

class TennisCourt extends StatelessWidget {
  const TennisCourt({
    super.key,
    this.onToggleSelection,
    this.colors = const TennisCourtColors(),
  });
  final ValueChanged<int?>? onToggleSelection;
  final TennisCourtColors colors;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = TennisCourtLayout(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          padding: EdgeInsets.all(10),
        );
        return Stack(
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: TennisCourtPainter(colors: colors, layout: layout),
            ),
            _GridPack(layout: layout, onToggleSelection: onToggleSelection),
          ],
        );
      },
    );
  }
}

class _GridPack extends StatefulWidget {
  const _GridPack({required this.layout, this.onToggleSelection});
  final ValueChanged<int?>? onToggleSelection;
  final TennisCourtLayout layout;
  @override
  State<StatefulWidget> createState() => _GridPackState();
}

class _GridPackState extends State<_GridPack> {
  int? _selectedId;
  void _onToggle(int? value) {
    setState(() => _selectedId = value);
    widget.onToggleSelection?.call(value);
  }

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
            [13],
          ],
          onToggle: _onToggle,
          selectedId: _selectedId,
        ),
        Grid(
          cols: 2,
          rows: 1,
          rect: widget.layout.leftServiceCourt,
          idMap: [
            [14, 15],
          ],
          onToggle: _onToggle,
          selectedId: _selectedId,
        ),
        Grid(
          cols: 2,
          rows: 1,
          rect: widget.layout.rightServiceCourt,
          idMap: [
            [16, 17],
          ],
          onToggle: _onToggle,
          selectedId: _selectedId,
        ),
      ],
    );
  }
}
