//import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/play/play.dart';
import 'package:robot_launcher_app/features/scenario/scenario.dart';
import 'widgets/app_bar_shell.dart';
import 'package:robot_launcher_app/features/home/home.dart';
import 'package:robot_launcher_app/features/manual/manual.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'widgets/bottom_navigation_bar_shell.dart';
import 'app_shell_view_model.dart';
import 'package:robot_launcher_app/shared/constants/states.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int currentIndex;
//  late final BleRepository repo;
//  late final AppShellViewModel viewModel;
  late RobotConnectionState _connectionState;
  final pages = const [
    HomePage(),
    PlayPage(),
    ManualPage(),
    ScenarioPage(),
  ];
  @override
  void initState() {
    currentIndex = 0;
    _connectionState = RobotConnectionState.connected;
//    repo = BleRepository(bleService: throw UnimplementedError());
//    viewModel = AppShellViewModel(repo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palet.backGround,
      appBar: AppBarShell(connectionState: _connectionState,),
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
      bottomNavigationBar: BottomNavigationBarShell(
        currentIndex: currentIndex,
        onTap:(newIndex) => setState(() => currentIndex = newIndex),
      ),
    );
  }
}