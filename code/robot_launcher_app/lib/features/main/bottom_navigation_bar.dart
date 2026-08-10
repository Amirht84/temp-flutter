import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView ({
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
      child: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: onTap,
        selectedItemColor: Palet.pressed,
        unselectedItemColor: Palet.disabled,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'temp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'temp'
          ),
        ],
      ),
    );
  }
}