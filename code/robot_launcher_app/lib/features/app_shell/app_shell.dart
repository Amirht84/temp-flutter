import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/play/play.dart';
import 'package:robot_launcher_app/features/scenario/scenario.dart';
import 'widgets/app_bar_shell.dart';
import 'package:robot_launcher_app/features/home/home.dart';
import 'package:robot_launcher_app/features/manual/manual.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'widgets/bottom_navigation_bar_shell.dart';
import 'connection_view_model.dart';
import 'package:robot_launcher_app/shared/constants/states.dart';
import 'mode_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int currentIndex;
  late final BleRepository _repo;
  late final ModeViewModel _modeViewModel;
  late final ConnectionViewModel _connectionViewModel;
  late RobotConnectionState _connectionState;

  PageState get _pageState {
    switch(currentIndex){
      case 0 : return .home;
      case 1 : return .play;
      case 2 : return .manual;
      case 3 : return .scenario;
      default : throw StateError('not expected to be here');
    }
  }
  @override
  void initState() {
    currentIndex = 0;
    _connectionState = RobotConnectionState.disconnected;
    _repo = BleRepository();
    _connectionViewModel = ConnectionViewModel(_repo);
    _modeViewModel = ModeViewModel(_repo);
    _modeViewModel.addListener(_modeListener);
    _connectionViewModel.addListener(_connectionListener);
    super.initState();
  }
  void _modeListener() {
    if(_connectionState == .connected) {
      _modeViewModel.pushMode();
    }
  }
  void _connectionListener() {
    setState(() {
      switch ((_connectionViewModel.isConnected, _connectionViewModel.isConnecting, _connectionViewModel.isScanning)){
        case (true, _, _):
          _connectionState = RobotConnectionState.connected;
      
        case (false, false, false):
          _connectionState = RobotConnectionState.disconnected;
      
        case (_, true, _):
          _connectionState = RobotConnectionState.connecting;
      
        case (_, _, true):
          _connectionState = RobotConnectionState.scanning;
      }
      if(_connectionState == .connected){
        _modeViewModel.pushMode();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(modeViewModel: _modeViewModel, isDisabled: !_connectionViewModel.isConnected),
      PlayPage(modeViewModel: _modeViewModel, isDisabled: !_connectionViewModel.isConnected),
      ManualPage(repo: _repo, isDisabled: !_connectionViewModel.isConnected, modeViewModel: _modeViewModel),
      ScenarioPage(modeViewModel: _modeViewModel, isDisabled: !_connectionViewModel.isConnected),
    ];
    return Scaffold(
      backgroundColor: Palet.backGround,
      appBar: AppBarShell(
        connectionState: _connectionState,
        onTap: (){
          if(_connectionState == RobotConnectionState.connected) {
            _connectionViewModel.disconnect();
          } else if (_connectionState == RobotConnectionState.disconnected) {
            _connectionViewModel.connect();
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
        onTap:(newIndex) => setState(() {
          currentIndex = newIndex;
          _modeViewModel.setPage(_pageState);
        }
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectionViewModel.removeListener(_connectionListener);
    _connectionViewModel.dispose();
    _repo.dispose();
    _modeViewModel.removeListener(_modeListener);
    _modeViewModel.dispose();
    super.dispose();
  }
}