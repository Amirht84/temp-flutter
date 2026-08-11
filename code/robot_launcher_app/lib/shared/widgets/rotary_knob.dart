import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/widgets/texts.dart';
import 'package:rotary_knob/rotary_knob.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

class RotaryKnobCard extends StatefulWidget {
  const RotaryKnobCard({
    super.key,
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.unit,
  });

  final String title;
  final double minValue;
  final double maxValue;
  final String unit;

  @override
  State<StatefulWidget> createState() => _RotaryKnobCardState();
}

class _RotaryKnobCardState extends State<RotaryKnobCard> {
  late double value;

  @override
  void initState() {
    value = (widget.maxValue + widget.minValue) / 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleText(widget.title),
          ValueText('${value.toInt()}${widget.unit}'),
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: RotaryKnob(
                value: value,
                maxValue: 25,
                minValue: -25,
                startAngle: -140,
                sweepAngle: 100,
                onChanged: (newValue) => setState(() => value = newValue),
                style: const RotaryKnobStyle(
                  normal: RotaryKnobAppearance(
                    shadowBlurRadius: 1,
                    majorDivisions: 2,
                    minorDivisions: 10,
                    indicatorColor: Palet.primaryAccent,
                    boundryColor: Palet.primaryAccent,
                  ),
                  pressed: RotaryKnobAppearance(
                    shadowBlurRadius: 10,
                    majorDivisions: 2,
                    minorDivisions: 10,
                    indicatorColor: Palet.primaryAccent,
                    boundryColor: Palet.primaryAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
