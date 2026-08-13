import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';

class ScenarioPage extends StatelessWidget {
  const ScenarioPage({
    super.key
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text("coming soon...")
          )
        ),
        GreenButton(iconPath: AppAssets.random, text: "Random", onPressed: () => 0),
        RedButton(iconPath: AppAssets.stop, text: "Stop!", onPressed: () => 0),

      ]
    );
  }
}