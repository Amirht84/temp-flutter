import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

class BottomNavigationBarShell extends StatelessWidget {
  const BottomNavigationBarShell({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: NavigationBar(
        backgroundColor: Palet.secondBackground,
        selectedIndex: currentIndex,
        indicatorColor: Palet.pressed,
        onDestinationSelected: onTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'HOME'),
          NavigationDestination(icon: Icon(Icons.play_arrow), label: 'PLAY'),
          NavigationDestination(icon: Icon(Icons.smart_toy), label: 'AI'),
          NavigationDestination(
            icon: Icon(Icons.perm_data_setting_sharp),
            label: 'MANUAL',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_tree_outlined),
            label: 'SCENARIO',
          ),
        ],
      ),
    );
  }
}
