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
    required this.isDisabled,
    required this.onChangedEnd,
  });

  final String title;
  final double minValue;
  final double maxValue;
  final String unit;
  final bool isDisabled;

  final ValueChanged<double> onChangedEnd;
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
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: RotaryKnob(
                value: value,
                maxValue: 90,
                minValue: -90,
                startAngle: -180,
                sweepAngle: 180,
                onChangedEnd: widget.isDisabled 
                  ? null 
                  : (newValue) {
                    widget.onChangedEnd(newValue);
                    setState(() => value = 0);
                  }
                ,
                onChanged: widget.isDisabled ? (_){} : (newValue) => setState(() => value = newValue),
                style: RotaryKnobStyle(
                  normal: RotaryKnobAppearance(
                    shadowBlurRadius: 1,
                    majorDivisions: 4,
                    minorDivisions: 15,
                    indicatorColor: widget.isDisabled ? Palet.disabled : Palet.primaryAccent,
                    boundryColor: widget.isDisabled ? Palet.disabled : Palet.primaryAccent,
                  ),
                  pressed: RotaryKnobAppearance(
                    shadowBlurRadius: widget.isDisabled ? 1 : 10,
                    majorDivisions: 4,
                    minorDivisions: 15,
                    indicatorColor: widget.isDisabled ? Palet.disabled : Palet.primaryAccent,
                    boundryColor: widget.isDisabled ? Palet.disabled : Palet.primaryAccent,
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
