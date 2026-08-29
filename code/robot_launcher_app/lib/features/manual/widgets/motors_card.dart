import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/manual/manual_view_model.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:robot_launcher_app/shared/widgets/sliders.dart';
import 'package:robot_launcher_app/shared/constants/dictie.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';

class MotorsCard extends StatefulWidget {
  const MotorsCard({
    super.key,
    required this.isDisabled,
    required this.manualViewModel,
  });

  final bool isDisabled;
  final ManualViewModel manualViewModel;
  @override
  State<StatefulWidget> createState() => _MotorsCardState();
}

class _MotorsCardState extends State<MotorsCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlexibleSlider(
            minValue: 0,
            maxValue: 100,
            title: 'Up Wheel Speed',
            unit: Units.percent,
            isDisabled: widget.isDisabled,
            onChangedEnd: (value) {
              widget.manualViewModel.setUpMotor(value.toInt());
            },
          ),
          HorizonDivider(),
          FlexibleSlider(
            minValue: 0,
            maxValue: 100,
            title: 'Down Wheel Speed',
            unit: Units.percent,
            isDisabled: widget.isDisabled,
            onChangedEnd: (value) {
              widget.manualViewModel.setDownMotor(value.toInt());
            },
          ),
        ],
      ),
    );
  }
}
