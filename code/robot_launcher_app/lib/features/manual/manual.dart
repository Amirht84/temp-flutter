import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/widgets/sliders.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';
import 'package:robot_launcher_app/shared/constants/dictie.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';
import 'package:robot_launcher_app/shared/widgets/rotary_knob.dart';

class ManualPage extends StatelessWidget {
  const ManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlexibleSlider(
          minValue: 0,
          maxValue: 100,
          title: 'Up Wheel Speed',
          unit: Units.rpm,
        ),
        HorizonDivider(),
        FlexibleSlider(
          minValue: 0,
          maxValue: 100,
          title: 'Down Wheel Speed',
          unit: Units.rpm,
        ),
        HorizonDivider(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: FlexibleSlider(
                  isVertical: true,
                  minValue: 0,
                  maxValue: 100,
                  title: 'Vertical Degree',
                  unit: Units.degree,
                ),
              ),
              VerticDivider(),
              Expanded(
                flex: 1,
                child: RotaryKnobCard(
                  title: "Horizontal Degree",
                  minValue: -25,
                  maxValue: 25,
                  unit: Units.degree,
                ),
              ),
            ],
          ),
        ),
        GreenButton(
          iconPath: AppAssets.tennisBall,
          text: "Launch!",
          onPressed: () => 0,
        ),
        RedButton(iconPath: AppAssets.stop, text: "Stop!", onPressed: () => 0),
      ],
    );
  }
}
