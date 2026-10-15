import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:robot_launcher_app/shared/widgets/sliders.dart';

class DelaySliderCard extends StatelessWidget {
  const DelaySliderCard({super.key, required this.onChangedEnd});
  final ValueChanged<double> onChangedEnd;
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: FlexibleSlider(
              minValue: 2,
              maxValue: 10,
              title: 'Delay',
              onChangedEnd: (_) {},
              mode: .titleHorizon,
              unit: 's',
            ),
          ),
        ],
      ),
    );
  }
}
