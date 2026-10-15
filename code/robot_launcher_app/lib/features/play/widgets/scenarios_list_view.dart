import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/play/play_view_model.dart';
import 'package:robot_launcher_app/shared/widgets/tab_item.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';

class ScenariosListView extends StatelessWidget {
  const ScenariosListView({
    super.key,
    required this.scenarios,
    required this.onNewPressed,
  });
  final VoidCallback onNewPressed;
  final List<ScenarioHeader> scenarios;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Saved Scenarios',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        HorizonDivider(hasPadding: false),
        Expanded(
          child: ListView.builder(
            itemCount: scenarios.length,
            itemBuilder: ((context, index) {
              return TabItem(header: scenarios[index]);
            }),
          ),
        ),
        HorizonDivider(hasPadding: false),
        GreenButton(
          text: 'Add New',
          onPressed: onNewPressed,
          iconPath: AppAssets.newCross,
        ),
      ],
    );
  }
}
