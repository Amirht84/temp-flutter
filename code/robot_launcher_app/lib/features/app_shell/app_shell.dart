import 'package:core/core.dart';
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
import 'package:core/core.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int currentIndex;
  late final BleRepository _repo;
  late final AppShellViewModel _viewModel;
  late RobotConnectionState _connectionState;
  @override
  void initState() {
    currentIndex = 0;
    _connectionState = RobotConnectionState.disconnected;
    _repo = BleRepository();
    _viewModel = AppShellViewModel(_repo);
    _viewModel.addListener(_listener);
    super.initState();
  }
  void _listener() {
    setState(() {
      switch ((_viewModel.isConnected, _viewModel.isConnecting, _viewModel.isScanning)){
        case (true, _, _):
          _connectionState = RobotConnectionState.connected;
      
        case (false, false, false):
          _connectionState = RobotConnectionState.disconnected;
      
        case (_, true, _):
          _connectionState = RobotConnectionState.connecting;
      
        case (_, _, true):
          _connectionState = RobotConnectionState.scanning;
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(),
      PlayPage(),
      ManualPage(repo: _repo, isDisabled: !_viewModel.isConnected),
      ScenarioPage(),
    ];
    return Scaffold(
      backgroundColor: Palet.backGround,
      appBar: AppBarShell(
        connectionState: _connectionState,
        onTap: (){
          if(_connectionState == RobotConnectionState.connected) {
            _viewModel.disconnect();
          } else if (_connectionState == RobotConnectionState.disconnected) {
            _viewModel.connect();
          }
        },
        ),
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

  @override
  void dispose() {
    _viewModel.removeListener(_listener);
    _viewModel.dispose();
    _repo.dispose();
    super.dispose();
  }
}