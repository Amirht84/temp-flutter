import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({
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
        RedButton(iconPath: AppAssets.stop, text: "Stop!", onPressed: () => 0),

      ]
    );
  }
}