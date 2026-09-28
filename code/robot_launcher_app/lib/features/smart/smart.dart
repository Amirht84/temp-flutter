import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/app_shell/mode_view_model.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';

class SmartPage extends StatefulWidget {
  const SmartPage({
    super.key,
    required this.modeViewModel,
    this.isDisabled = false,
  });

  final ModeViewModel modeViewModel;
  final bool isDisabled;
  @override
  State<StatefulWidget> createState() => _SmartPageState();
}

class _SmartPageState extends State<SmartPage> {
  @override
  Widget build(BuildContext context) {
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
        children: [
          Expanded(child: Center(child: Text("coming soon..."))),
          stopButton,
        ],
      ),
    );
  }
}
