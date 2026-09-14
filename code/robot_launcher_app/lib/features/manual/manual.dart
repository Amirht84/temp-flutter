import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/app_shell/mode_view_model.dart';
import 'package:robot_launcher_app/features/manual/manual_view_model.dart';
import 'package:robot_launcher_app/features/manual/widgets/rotary_card.dart';
import 'package:robot_launcher_app/features/manual/widgets/sliders_partison.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';

class ManualPage extends StatefulWidget {
  const ManualPage({
    super.key,
    required this.repo,
    required this.modeViewModel,
    this.isDisabled = false,
  });
  final bool isDisabled;
  final BleRepository repo;
  final ModeViewModel modeViewModel;
  @override
  State<StatefulWidget> createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  late ManualViewModel _manualViewModel;
  @override
  void initState() {
    super.initState();
    _manualViewModel = ManualViewModel(widget.repo);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.isDisabled || widget.modeViewModel.isStopped;
    final stopButton = widget.modeViewModel.isStopped
        ? GreenButton(
            iconPath: AppAssets.start,
            onPressed: () => setState(widget.modeViewModel.switchStop),
            text: 'Start',
            isDisabled: widget.isDisabled,
          )
        : RedButton(
            text: 'Stop',
            onPressed: () => setState(widget.modeViewModel.switchStop),
            iconPath: AppAssets.stop,
            isDisabled: widget.isDisabled,
          );

    return Padding(
      padding: EdgeInsets.all(Dimensions.bodyPadding),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SlidersPartison(
          manualViewModel: _manualViewModel,
          isDisabled: isDisabled,
        ),
        EmptyDivider(),
        Expanded(
          child: RotaryCard(
            manualViewModel: _manualViewModel,
            isDisabled: isDisabled,
          ),
        ),
        EmptyDivider(),
        GreenButton(
          isDisabled: isDisabled,
          iconPath: AppAssets.tennisBall,
          text: "Launch!",
          onPressed: () => _manualViewModel.launch(),
        ),
        stopButton,
      ],
    ));
  }
}
