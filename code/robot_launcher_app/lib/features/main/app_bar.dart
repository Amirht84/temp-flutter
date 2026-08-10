import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Palet.secondBackground,
      title: SizedBox(
        width: Dimensions.titleContextSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.circle, color: Palet.success),
            Text("Connected"),
          ],
        ),
      ),
    );
  }
}