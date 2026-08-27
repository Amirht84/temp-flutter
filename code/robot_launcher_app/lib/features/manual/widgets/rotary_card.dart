import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/manual/manual_view_model.dart';
import 'package:robot_launcher_app/shared/constants/dictie.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';
import 'package:robot_launcher_app/shared/widgets/joystick.dart';
import 'package:robot_launcher_app/shared/widgets/rotary_knob.dart';

class RotaryCard extends StatefulWidget {
  const RotaryCard({
    super.key,
    required this.manualViewModel,
    this.isDisabled = false,
  });
  final ManualViewModel manualViewModel;
  final bool isDisabled;

  @override
  State<StatefulWidget> createState() => _RotaryCardState();
}

class _RotaryCardState extends State<RotaryCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: JoystickCard(
              title: "JoyStick",
              onChanged: (x, y) => widget.manualViewModel.setJoystick(x, y),
              isDisabled: widget.isDisabled,
            ),
          ),
          VerticDivider(),
          Expanded(
            flex: 1,
            child: RotaryKnobCard(
              title: "Horizontal Degree",
              minValue: -90,
              maxValue: 90,
              unit: Units.degree,
              isDisabled: widget.isDisabled,
              onChanged: (value) {
                widget.manualViewModel.setHorizonAngle(value);
              },
              onChangedEnd: (_) {
                widget.manualViewModel.setHorizonAngle(0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
