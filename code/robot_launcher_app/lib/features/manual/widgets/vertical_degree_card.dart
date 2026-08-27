import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/manual/manual_view_model.dart';
import 'package:robot_launcher_app/shared/constants/dictie.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:robot_launcher_app/shared/widgets/sliders.dart';

class VerticalDegreeCard extends StatefulWidget {
  const VerticalDegreeCard({
    super.key,
    required this.manualViewModel,
    this.isDisabled = false,
  });
  final ManualViewModel manualViewModel;
  final bool isDisabled;

  @override
  State<StatefulWidget> createState() => _VerticalDegreeCardState();
}

class _VerticalDegreeCardState extends State<VerticalDegreeCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: FlexibleSlider(
        minValue: 20,
        maxValue: 75,
        title: "Vertical Degree",
        isVertical: true,
        onChangedEnd: (value) => widget.manualViewModel.setVerticAngle(value),
        isDisabled: widget.isDisabled,
        unit: Units.degree,
      ),
    );
  }
}
