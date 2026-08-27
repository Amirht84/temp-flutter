import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/manual/manual_view_model.dart';
import 'package:robot_launcher_app/features/manual/widgets/motors_card.dart';
import 'package:robot_launcher_app/features/manual/widgets/vertical_degree_card.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';
import 'package:robot_launcher_app/shared/widgets/sliders.dart';

class SlidersPartison extends StatelessWidget {
  const SlidersPartison({
    super.key,
    required this.manualViewModel,
    required this.isDisabled,
  });

  final ManualViewModel manualViewModel;
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: MotorsCard(
              isDisabled: isDisabled,
              manualViewModel: manualViewModel,
            ),
          ),
          EmptyDivider(isVertical: true),
          Expanded(
            flex: 1,
            child: VerticalDegreeCard(
              manualViewModel: manualViewModel,
              isDisabled: isDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
