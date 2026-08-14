import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/manual/manual_view_model.dart';
import 'package:robot_launcher_app/shared/widgets/sliders.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';
import 'package:robot_launcher_app/shared/constants/dictie.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';
import 'package:robot_launcher_app/shared/widgets/rotary_knob.dart';

class ManualPage extends StatefulWidget {
  const ManualPage({
    super.key,
    required this.repo,
    this.isDisabled = false,
  });
  final bool isDisabled;
  final BleRepository repo;
  @override
  State<StatefulWidget> createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage>{
  late ManualViewModel _manualViewModel;
  @override
  void initState(){
    super.initState();
    _manualViewModel = ManualViewModel(widget.repo);
  }
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
          isDisabled: widget.isDisabled,
          onChangedEnd: (value) {
            _manualViewModel.setUpMotor(value.toInt());
          },
        ),
        HorizonDivider(),
        FlexibleSlider(
          minValue: 0,
          maxValue: 100,
          title: 'Down Wheel Speed',
          unit: Units.rpm,
          isDisabled: widget.isDisabled,
          onChangedEnd:(value) {
            _manualViewModel.setDownMotor(value.toInt());
          },
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
                  isDisabled: widget.isDisabled,
                  onChangedEnd:(value) {
                    _manualViewModel.setVerticAngle(value);
                  },
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
                  isDisabled: widget.isDisabled,
                  onChangedEnd: (value) {
                    _manualViewModel.setHorizonAngle(value);
                  }
                ),
              ),
            ],
          ),
        ),
        GreenButton(
          isDisabled: widget.isDisabled,
          iconPath: AppAssets.tennisBall,
          text: "Launch!",
          onPressed: () => _manualViewModel.launch(),
        ),
        RedButton(iconPath: AppAssets.stop, text: "Stop!", onPressed: () => 0),
      ],
    );
  }
}
