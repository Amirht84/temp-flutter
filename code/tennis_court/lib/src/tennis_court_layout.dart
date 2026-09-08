import 'package:flutter/widgets.dart';
import 'package:tennis_court/src/tennis_court_constants.dart';

class CourtLine {
  const CourtLine({required this.start, required this.end});

  final Offset start;
  final Offset end;
}

class TennisCourtLayout {
  const TennisCourtLayout({required double width, required double height})
    : _width = width,
      _height = height;

  final double _width;
  final double _height;

  // -------------------------
  // Overall dimensions
  // -------------------------

  double get _padding {
    return _width * TennisCourtConstants.paddingFlex / 100;
  }

  double get _courtWidth {
    return _width - 2 * _padding;
  }

  double get _courtHeight {
    return _height - 2 * _padding;
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
    return Offset(x + _padding, y + _padding);
  }

  // -------------------------
  // Court
  // -------------------------

  Rect get courtRect {
    return Rect.fromLTWH(_padding, _padding, _courtWidth, _courtHeight);
  }

  // -------------------------
  // Net
  // -------------------------

  CourtLine get net {
    return CourtLine(
      start: Offset(_padding, _height / 2),
      end: Offset(_width - _padding, _height / 2),
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
    return Rect.fromLTWH(_padding, _padding, _tramLineWidth, _courtHeight / 2);
  }

  Rect get rightDoubles {
    return Rect.fromLTWH(
      _padding + _tramLineWidth + _singlesWidth,
      _padding,
      _tramLineWidth,
      _courtHeight / 2,
    );
  }

  // -------------------------
  // No Man's Land
  // -------------------------

  Rect get noMansLand {
    return Rect.fromLTWH(
      _padding + _tramLineWidth,
      _padding,
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
      _padding + _tramLineWidth,
      _padding + _noMansLandHeight,
      _singlesWidth / 2,
      _courtHeight / 2 - _noMansLandHeight,
    );
  }

  Rect get rightServiceCourt {
    return Rect.fromLTWH(
      _padding + _tramLineWidth + _singlesWidth / 2,
      _padding + _noMansLandHeight,
      _singlesWidth / 2,
      _courtHeight / 2 - _noMansLandHeight,
    );
  }
}
