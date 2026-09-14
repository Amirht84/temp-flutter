import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/app_shell/mode_view_model.dart';
import 'package:robot_launcher_app/features/play/widgets/spin_card.dart';
import 'package:robot_launcher_app/features/play/widgets/tennis_court_card.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({
    super.key,
    required this.modeViewModel,
    this.isDisabled = false,
  });

  final ModeViewModel modeViewModel;
  final bool isDisabled;
  @override
  State<StatefulWidget> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || widget.modeViewModel.isStopped;
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
        Expanded(
          child: SizedBox(
              width: 300,
              child: FractionallySizedBox(
            heightFactor: 0.9,
            child: TennisCourtCard(
              isDisabled: isDisabled,
            )
            ))
          ),
      SpinCard(isDisabled: isDisabled,),
      EmptyDivider(),
      GreenButton(
          isDisabled: isDisabled,
          iconPath: AppAssets.tennisBall,
          text: "Launch!",
          onPressed: () {/* to be implemented */},
        ),
        stopButton,
      ],
    ));
  }
}
