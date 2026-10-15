import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/app_shell/mode_view_model.dart';
import 'package:robot_launcher_app/features/play/pages/idle_page.dart';
import 'package:robot_launcher_app/features/play/pages/scenario_builder_page.dart';

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
    return IdlePage(
      modeViewModel: widget.modeViewModel,
      isDisabled: widget.isDisabled,
      onNewPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ScenarioBuilderPage(modeViewModel: widget.modeViewModel),
        ),
      ),
    );
  }
}
