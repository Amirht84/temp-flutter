import 'package:flutter/widgets.dart';
import 'package:tennis_court/src/tennis_court_constants.dart';

class CourtLine {
  const CourtLine({required this.start, required this.end});

  final Offset start;
  final Offset end;
}

class TennisCourtLayout {
  const TennisCourtLayout({required double width, required double height, required this.padding})
    : _width = width,
      _height = height;

  final double _width;
  final double _height;
  final EdgeInsets padding;

  // -------------------------
  // Overall dimensions
  // -------------------------

  double get _courtWidth {
    return _width - padding.left - padding.right;
  }

  double get _courtHeight {
    return _height - padding.top - padding.bottom;
  }

  // -------------------------
  // Court proportions
  // -------------------------

  double get _tramLineWidth {
    return _courtWidth *
        TennisCourtConstants.doublesWidthFlex /
        TennisCourtConstants.courtWidthFlex;
  }

  double get _singlesWidth {
    return _courtWidth - 2 * _tramLineWidth;
  }

  double get _noMansLandHeight {
    return _courtHeight *
        TennisCourtConstants.noMansLandHeightFlex /
        TennisCourtConstants.courtHeightFlex;
  }

  // -------------------------
  // Coordinate conversion
  // -------------------------

  Offset _fromCourtPos(double x, double y) {
    return Offset(x + padding.left, y + padding.top);
  }

  // -------------------------
  // whole rect
  // -------------------------
  Rect get wholeRect {
    return Rect.fromLTWH(
      0,
      0,
      _width,
      _height
    );
  }
  // -------------------------
  // Court
  // -------------------------

  Rect get courtRect {
    return Rect.fromLTWH(padding.left, padding.top, _courtWidth, _courtHeight);
  }

  // -------------------------
  // Net
  // -------------------------

  CourtLine get net {
    return CourtLine(
      start: Offset(padding.left, padding.top + _courtHeight / 2),
      end: Offset(_width - padding.right, padding.top + _courtHeight / 2),
    );
  }

  // -------------------------
  // Singles side lines
  // -------------------------

  List<CourtLine> get singlesSideLines {
    final leftLine = CourtLine(
      start: _fromCourtPos(_tramLineWidth, 0),
      end: _fromCourtPos(_tramLineWidth, _courtHeight),
    );

    final rightLine = CourtLine(
      start: _fromCourtPos(_courtWidth - _tramLineWidth, 0),
      end: _fromCourtPos(_courtWidth - _tramLineWidth, _courtHeight),
    );

    return [leftLine, rightLine];
  }

  // -------------------------
  // Service lines
  // -------------------------

  List<CourtLine> get serviceLines {
    final topLine = CourtLine(
      start: _fromCourtPos(
        _tramLineWidth + TennisCourtConstants.lineWidth / 2,
        _noMansLandHeight,
      ),
      end: _fromCourtPos(
        _courtWidth - _tramLineWidth - TennisCourtConstants.lineWidth / 2,
        _noMansLandHeight,
      ),
    );

    final bottomLine = CourtLine(
      start: _fromCourtPos(
        _tramLineWidth + TennisCourtConstants.lineWidth / 2,
        _courtHeight - _noMansLandHeight,
      ),
      end: _fromCourtPos(
        _courtWidth - _tramLineWidth - TennisCourtConstants.lineWidth / 2,
        _courtHeight - _noMansLandHeight,
      ),
    );

    return [topLine, bottomLine];
  }

  // -------------------------
  // Center service line
  // -------------------------

  CourtLine get centerServiceLine {
    final centerX = _tramLineWidth + _singlesWidth / 2;

    return CourtLine(
      start: _fromCourtPos(
        centerX,
        _noMansLandHeight + TennisCourtConstants.lineWidth / 2,
      ),
      end: _fromCourtPos(
        centerX,
        _courtHeight - _noMansLandHeight - TennisCourtConstants.lineWidth / 2,
      ),
    );
  }

  // -------------------------
  // Doubles zones
  // -------------------------

  Rect get leftDoubles {
    return Rect.fromLTWH(padding.left, padding.top, _tramLineWidth, _courtHeight / 2);
  }

  Rect get rightDoubles {
    return Rect.fromLTWH(
      padding.left + _tramLineWidth + _singlesWidth,
      padding.top,
      _tramLineWidth,
      _courtHeight / 2,
    );
  }

  // -------------------------
  // No Man's Land
  // -------------------------

  Rect get noMansLand {
    return Rect.fromLTWH(
      padding.left + _tramLineWidth,
      padding.top,
      _singlesWidth,
      _noMansLandHeight,
    );
  }

  List<int> get doublesHeightFlexList {
    return [
      TennisCourtConstants.halfNoMansLandHeightFlex,
      TennisCourtConstants.halfNoMansLandHeightFlex,
      TennisCourtConstants.halfCourtHeightFlex -
          TennisCourtConstants.noMansLandHeightFlex,
    ];
  }

  Rect get leftServiceCourt {
    return Rect.fromLTWH(
      padding.left + _tramLineWidth,
      padding.top + _noMansLandHeight,
      _singlesWidth / 2,
      _courtHeight / 2 - _noMansLandHeight,
    );
  }

  Rect get rightServiceCourt {
    return Rect.fromLTWH(
      padding.left + _tramLineWidth + _singlesWidth / 2,
      padding.top + _noMansLandHeight,
      _singlesWidth / 2,
      _courtHeight / 2 - _noMansLandHeight,
    );
  }
}
