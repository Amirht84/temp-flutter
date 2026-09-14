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
    this.padding = const EdgeInsets.all(0),
    this.borderRadius = BorderRadius.zero,
  });
  final ValueChanged<int?>? onToggleSelection;
  final TennisCourtColors colors;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = TennisCourtLayout(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          padding: padding,
        );
        return Stack(
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: TennisCourtPainter(colors: colors, layout: layout, borderRadius: borderRadius),
            ),
            _GridPack(layout: layout, onToggleSelection: onToggleSelection, colors: colors),
          ],
        );
      },
    );
  }
}

class _GridPack extends StatefulWidget {
  const _GridPack({required this.layout, this.onToggleSelection, required this.colors});
  final ValueChanged<int?>? onToggleSelection;
  final TennisCourtLayout layout;
  final TennisCourtColors colors;
  @override
  State<StatefulWidget> createState() => _GridPackState();
}

class _GridPackState extends State<_GridPack> {
  int? _selectedId;
  void _onToggle(int? value) {
    setState(() => _selectedId = value);
    widget.onToggleSelection!.call(value);
  }
  
  @override
  void initState() {
    _selectedId = null;
    super.initState();
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
          colors: widget.colors,
          onToggle: widget.onToggleSelection != null ? _onToggle : null,
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
          colors: widget.colors,
          onToggle: widget.onToggleSelection != null ? _onToggle : null,
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
          colors: widget.colors,
          onToggle: widget.onToggleSelection != null ? _onToggle : null,
          selectedId: _selectedId,
        ),
        Grid(
          cols: 2,
          rows: 1,
          rect: widget.layout.leftServiceCourt,
          idMap: [
            [14, 15],
          ],
          colors: widget.colors,
          onToggle: widget.onToggleSelection != null ? _onToggle : null,
          selectedId: _selectedId,
        ),
        Grid(
          cols: 2,
          rows: 1,
          rect: widget.layout.rightServiceCourt,
          idMap: [
            [16, 17],
          ],
          colors: widget.colors,
          onToggle: widget.onToggleSelection != null ? _onToggle : null,
          selectedId: _selectedId,
        ),
      ],
    );
  }
}
