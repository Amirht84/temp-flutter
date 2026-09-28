import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/play/play.dart';
import 'package:robot_launcher_app/features/scenario/scenario.dart';
import 'package:robot_launcher_app/features/smart/smart.dart';
import 'widgets/app_bar_shell.dart';
import 'package:robot_launcher_app/features/home/home.dart';
import 'package:robot_launcher_app/features/manual/manual.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'widgets/bottom_navigation_bar_shell.dart';
import 'widgets/device_picker_sheet.dart';
import 'app_shell_view_model.dart';
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
  late final AppShellViewModel _appShellViewModel;
  late RobotConnectionState _connectionState;

  PageState get _pageState {
    switch (currentIndex) {
      case 0:
        return .home;
      case 1:
        return .play;
      case 2:
        return .smart;
      case 3:
        return .manual;
      case 4:
        return .scenario;
      default:
        throw StateError('not expected to be here');
    }
  }

  @override
  void initState() {
    currentIndex = 0;
    _connectionState = RobotConnectionState.disconnected;
    _repo = BleRepository();
    _appShellViewModel = AppShellViewModel(_repo);
    _modeViewModel = ModeViewModel(_repo);
    _modeViewModel.addListener(_modeListener);
    _appShellViewModel.addListener(_connectionListener);
    super.initState();
  }

  void _modeListener() {
    if (_connectionState == .connected) {
      _modeViewModel.pushMode();
    }
  }

  void _connectionListener() {
    setState(() {
      switch ((
        _appShellViewModel.isConnected,
        _appShellViewModel.isConnecting,
        _appShellViewModel.isScanning,
      )) {
        case (true, _, _):
          _connectionState = RobotConnectionState.connected;

        case (false, false, false):
          _connectionState = RobotConnectionState.disconnected;

        case (_, true, _):
          _connectionState = RobotConnectionState.connecting;

        case (_, _, true):
          _connectionState = RobotConnectionState.scanning;
      }
      if (_connectionState == .connected) {
        _modeViewModel.pushMode();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        modeViewModel: _modeViewModel,
        isDisabled: _appShellViewModel.isConnected,
      ),
      PlayPage(
        modeViewModel: _modeViewModel,
        isDisabled: _appShellViewModel.isConnected,
      ),
      SmartPage(
        modeViewModel: _modeViewModel,
        isDisabled: _appShellViewModel.isConnected,
      ),
      ManualPage(
        repo: _repo,
        isDisabled: _appShellViewModel.isConnected,
        modeViewModel: _modeViewModel,
      ),
      ScenarioPage(
        modeViewModel: _modeViewModel,
        isDisabled: _appShellViewModel.isConnected,
      ),
    ];
    return Scaffold(
      backgroundColor: Palet.backGround,
      appBar: AppBarShell(
        connectionState: _connectionState,
        onTap: () {
          if (_connectionState == RobotConnectionState.connected) {
            _appShellViewModel.disconnect();
          } else if (_connectionState == RobotConnectionState.disconnected) {
            DevicePickerSheet.show(context, _appShellViewModel);
          }
        },
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (child, animation) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        child: pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBarShell(
        currentIndex: currentIndex,
        onTap: (newIndex) => setState(() {
          currentIndex = newIndex;
          _modeViewModel.setPage(_pageState);
        }),
      ),
    );
  }

  @override
  void dispose() {
    _appShellViewModel.removeListener(_connectionListener);
    _appShellViewModel.dispose();
    _repo.dispose();
    _modeViewModel.removeListener(_modeListener);
    _modeViewModel.dispose();
    super.dispose();
  }
}
