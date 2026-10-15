import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/play/scenario_builder_view_model.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:robot_launcher_app/shared/widgets/texts.dart';

class TimeLineListView extends StatefulWidget {
  const TimeLineListView({super.key});

  @override
  State<StatefulWidget> createState() => _TimeLineListViewState();
}

class _TimeLineListViewState extends State<TimeLineListView> {
  late ScenarioBuilderViewModel scenarioBuilderViewModel;

  @override
  void initState() {
    scenarioBuilderViewModel = ScenarioBuilderViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: .min,
        children: [
          TitleText('Time Line'),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: .horizontal,
              itemCount: scenarioBuilderViewModel.shotsCount,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisSize: .min,
                  children: [
                    TimeLineEntry(
                      shot: scenarioBuilderViewModel.shots[index],
                      isSelected: index == scenarioBuilderViewModel.shotIndex,
                      onSelect: () => setState(
                        () => scenarioBuilderViewModel.changeIndex(index),
                      ),
                    ),
                    if (index == scenarioBuilderViewModel.shotsCount - 1)
                      WhiteBobble(
                        firstDesc: 'New',
                        secondDesc: "+",
                        onPressed: () => setState(
                          () => scenarioBuilderViewModel.addNewShotToEnd(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
    );
  }
}

class TimeLineEntry extends StatelessWidget {
  const TimeLineEntry({
    super.key,
    required this.shot,
    required this.isSelected,
    required this.onSelect,
  });
  final ScenarioShot shot;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        isSelected
            ? GreenBobble(
                firstDesc: 'Zone ${shot.zone}',
                secondDesc: '${shot.spin}',
                onPressed: onSelect,
              )
            : WhiteBobble(
                firstDesc: 'Zone ${shot.zone}',
                secondDesc: '${shot.spin}',
                onPressed: onSelect,
              ),
        _TimeDiff(shot.delay),
      ],
    );
  }
}

class _TimeDiff extends StatelessWidget {
  const _TimeDiff(this.time);
  final int time;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Column(
        mainAxisSize: .min,
        children: [
          Divider(),
          Text('${time}s', style: TextStyle(color: Palet.secondaryText)),
        ],
      ),
    );
  }
}
