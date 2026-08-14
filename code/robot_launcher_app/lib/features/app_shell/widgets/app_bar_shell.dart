import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/states.dart';
// import '../app_shell_view_model.dart';

class AppBarShell extends StatelessWidget implements PreferredSizeWidget {
  const AppBarShell({
    super.key,
    required this.connectionState,
    required this.onTap,
  });
  final RobotConnectionState connectionState;
  final GestureTapCallback onTap;



  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Palet.secondBackground,
      title: InkWell (
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: switch (connectionState) {
            RobotConnectionState.blueOff => [
              const Icon(Icons.circle, color: Palet.disabled),
              const SizedBox(width: Dimensions.titleContextSize),
              const Text('Bluetooth Off')
            ],
            RobotConnectionState.connected => [
              const Icon(Icons.circle, color: Palet.success),
              const SizedBox(width: Dimensions.titleContextSize),
              const Text('Connected'),
            ],
            RobotConnectionState.connecting => [
              const Icon(Icons.circle, color: Palet.warning),
              const SizedBox(width: Dimensions.titleContextSize),
              const Text('Connecting...')

            ],
            RobotConnectionState.disconnected => [
              const Icon(Icons.circle, color: Palet.error),
              const SizedBox(width: Dimensions.titleContextSize),
              const Text('Disconnected'),
            ],
            RobotConnectionState.scanning => [
              const Icon(Icons.circle, color: Palet.warning),
              const SizedBox(width: Dimensions.titleContextSize),
              const Text('Scanning...'),
            ],
          }
      
        ),
      ),
    );
  }
}