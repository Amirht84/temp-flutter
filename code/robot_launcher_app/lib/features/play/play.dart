import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/app_shell/mode_view_model.dart';
import 'package:robot_launcher_app/features/play/widgets/spin_card.dart';
import 'package:robot_launcher_app/features/play/widgets/tab.dart';
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
  late Position? _selectedTab;
  void _onTabPressed(Position position){
    setState((){
    if(_selectedTab == position) {
      _selectedTab = null;
    }else {
      _selectedTab = position;
    }});
  }
  @override
  void initState() {
    _selectedTab = null;
    super.initState();
  }

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
      padding: EdgeInsets.symmetric(vertical: Dimensions.bodyPadding),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: .center,
                  child: SizedBox(
                    width: 300,
                    child: TennisCourtCard(isDisabled: isDisabled),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: AppTab(
                    position: .left,
                    isSelected: _selectedTab == .left,
                    icon: Icons.smart_toy_sharp,
                    onPressed: () => _onTabPressed(.left),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: AppTab(
                    position: .right,
                    isSelected: _selectedTab == .right,
                    onPressed: () => _onTabPressed(.right),
                    icon: Icons.account_tree
                  ),
                ),
              ],
            ),
          ),
          EmptyDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.bodyPadding),
            child: Column(
              children: [
                SpinCard(isDisabled: isDisabled),
                EmptyDivider(),
                GreenButton(
                  isDisabled: isDisabled,
                  iconPath: AppAssets.tennisBall,
                  text: "Launch!",
                  onPressed: () {
                    /* to be implemented */
                  },
                ),
                stopButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
