import 'package:flutter/widgets.dart';
import 'package:tennis_court/src/tennis_court_constants.dart';

class CourtLine{
  const CourtLine({
    required this.start,
    required this.end,
  });

  final Offset start;
  final Offset end;
}
class TennisCourtLayout {
  const TennisCourtLayout({
    required double width,
    required double height,
  }): _width = width, _height = height;

  final double _width;
  final double _height;

  double get _padding => TennisCourtConstants.paddingFactor * _width;
  double get _courtHeight => _height - 2 * _padding;
  double get _courtWidth => _width - 2 * _padding;
  Offset _fromCourtPos(double x, double y) => Offset(
      x + _padding,
      y + _padding
    );
  double get _tramLineWidth => TennisCourtConstants.doublesWidthFactor * _courtWidth;
  double get _singlesWidth => _courtWidth - 2 * _tramLineWidth;
  double get _noMansLandHeight => _courtHeight * TennisCourtConstants.noMansLandHeightFactor;


  CourtLine get net {
    return CourtLine(
      start: Offset(0, _height / 2),
      end: Offset(_width, _height / 2)
    );
  }
  List<CourtLine> get boundaryLines{
    final leftLine = CourtLine(
      start: _fromCourtPos(
        0,
        0
      ),
      end: _fromCourtPos(
          0,
          _courtHeight
      ),
    );
    final downLine = CourtLine(
      start: _fromCourtPos(
          0,
          _courtHeight
      ),
      end: _fromCourtPos(
          _courtWidth,
          _courtHeight
      )
    );
    final rightLine = CourtLine(
      start: _fromCourtPos(
          _courtWidth,
          _courtHeight
      ),
      end: _fromCourtPos(
          _courtWidth,
          0
      )
    );
    final topLine = CourtLine(
      start: _fromCourtPos(
          _courtWidth,
          0
      ),
      end: _fromCourtPos(  
        0,
        0
      )
    );
    return [
      leftLine,
      downLine,
      rightLine,
      topLine
    ];
  }
  List<CourtLine> get singlesSideLines {
    final leftie = CourtLine(
      start: _fromCourtPos(
          _tramLineWidth,
          0
      ),
      end: _fromCourtPos(
          _tramLineWidth,
          _courtHeight
      )
    );
    final rightie = CourtLine(
      start: _fromCourtPos(
        _courtWidth - _tramLineWidth,
        0
      ),
      end: _fromCourtPos(
        _courtWidth - _tramLineWidth,
        _courtHeight
      )
    );
    return [
      leftie,
      rightie
    ];
  }
  List<CourtLine> get serviceLines {
    final upLine = CourtLine(
      start: _fromCourtPos(
        _tramLineWidth,
        _noMansLandHeight
      ),
      end: _fromCourtPos(
        _courtWidth - _tramLineWidth,
        _noMansLandHeight
      )
    );
    final downLine = CourtLine(
      start: _fromCourtPos(
        _tramLineWidth,
        _courtHeight - _noMansLandHeight
      ),
      end: _fromCourtPos(
        _courtWidth - _tramLineWidth,
        _courtHeight - _noMansLandHeight
      )
    );
    return [
      upLine,
      downLine
    ];
  }
  CourtLine get centerServiceLine {
    return CourtLine(
      start: _fromCourtPos(
        _tramLineWidth + _singlesWidth / 2,
        _noMansLandHeight
      ),
      end: _fromCourtPos(
        _tramLineWidth + _singlesWidth / 2,
        _courtHeight - _noMansLandHeight
      )
    );
  }
}