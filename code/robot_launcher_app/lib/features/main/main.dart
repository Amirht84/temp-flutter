import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'package:robot_launcher_app/features/home/home.dart';
import 'package:robot_launcher_app/features/manual/manual.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'bottom_navigation_bar.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int currentIndex;
  final pages = const [
    ManualPage(),
    HomePage(),
    HomePage(),
    HomePage(),
  ];
  @override
  void initState() {
    currentIndex = 0;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: Dimensions.bodyPadding),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation);

            return SlideTransition(
              position: offsetAnimation,
              child: child
            );
          },
          child: pages[currentIndex],
        )
      ),
      bottomNavigationBar: BottomNavigationBarView(
        currentIndex: currentIndex,
        onTap:(newIndex) => setState(() => currentIndex = newIndex),
      ),
    );
  }
}