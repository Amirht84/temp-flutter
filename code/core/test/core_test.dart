// ============================================================
// FILE: bin/robot_cli.dart
// Standalone command-line harness for the core BLE logic.
// Run with:  dart run bin/robot_cli.dart
//
// This talks to BleRepository exactly the way a real ViewModel
// would, but backed by MockBleService instead of real hardware,
// so you (and your friend) can validate encode/decode, checksum
// handling, and stream wiring before the UI/ViewModel exist.
// ============================================================

import 'dart:async';
import 'dart:io';

import '../lib/src/ble/ble_device.dart';
import '../lib/src/ble/ble_repository.dart';
import '../lib/src/ble/mock_ble_service.dart';
import '../lib/src/models/robot_command.dart';
import '../lib/src/models/robot_state.dart';

Future<void> main() async {
  final mock = MockBleService();
  final repo = BleRepository(bleService: mock);

  BleDevice? connectedDevice;
  RobotState lastState = RobotState.initial;

  final stateSub = repo.robotStateStream.listen((state) {
    lastState = state;
    print('📡 telemetry: $state');
  });
  final connSub = repo.connectionStream.listen((connected) {
    print(connected ? '✅ connection established' : '⚠️  connection lost');
  });

  print('=== Tennis Robot Core CLI ===');
  print("Type 'help' for commands.\n");

  var running = true;
  while (running) {
    stdout.write('> ');
    final line = stdin.readLineSync()?.trim() ?? '';
    if (line.isEmpty) continue;
    final parts = line.split(RegExp(r'\s+'));
    final cmd = parts.first.toLowerCase();
    final arg = parts.length > 1 ? parts[1] : null;

    try {
      switch (cmd) {
        case 'help':
          _printHelp();

        case 'scan':
          print('Scanning for 3s...');
          final devices = <BleDevice>[];
          await for (final d in repo.scanForRobots().timeout(
            const Duration(seconds: 3),
            onTimeout: (s) => s.close(),
          )) {
            devices.add(d);
            print('  [${devices.length}] ${d.name} (${d.id})  rssi=${d.rssi}');
          }
          if (devices.isEmpty) {
            print('No devices found.');
          } else {
            print("Use 'connect <index>' to connect, e.g. 'connect 1'.");
            _lastScan = devices;
          }

        case 'connect':
          if (arg == null || _lastScan.isEmpty) {
            print("Run 'scan' first, then 'connect <index>'.");
            break;
          }
          final idx = int.tryParse(arg);
          if (idx == null || idx < 1 || idx > _lastScan.length) {
            print('Invalid index.');
            break;
          }
          connectedDevice = _lastScan[idx - 1];
          print('Connecting to ${connectedDevice.name}...');
          await repo.connectToRobot(connectedDevice);
          await Future.delayed(const Duration(seconds: 1));

        case 'disconnect':
          await repo.disconnectFromRobot();
          connectedDevice = null;

        case 'top':
          await _requireConnected(connectedDevice, () async {
            final speed = _parseIntArg(arg, 'speed (0-100)');
            if (speed == null) return;
            await repo.sendCommand(RobotCommand.topMotorSpeed(speed));
            print('Sent: top motor speed = $speed%');
            await Future.delayed(const Duration(seconds: 1));
          });

        case 'bottom':
          await _requireConnected(connectedDevice, () async {
            final speed = _parseIntArg(arg, 'speed (0-100)');
            if (speed == null) return;
            await repo.sendCommand(RobotCommand.bottomMotorSpeed(speed));
            print('Sent: bottom motor speed = $speed%');
            await Future.delayed(const Duration(seconds: 1));
          });

        case 'vertical':
          await _requireConnected(connectedDevice, () async {
            final deg = _parseIntArg(arg, 'degrees (-45 to 45)');
            if (deg == null) return;
            await repo.sendCommand(RobotCommand.verticalAngle(deg));
            print('Sent: vertical angle = $deg°');
            await Future.delayed(const Duration(seconds: 1));
          });

        case 'horizontal':
          await _requireConnected(connectedDevice, () async {
            final deg = _parseIntArg(arg, 'degrees (-180 to 180)');
            if (deg == null) return;
            await repo.sendCommand(RobotCommand.horizontalAngle(deg));
            print('Sent: horizontal angle = $deg°');
            await Future.delayed(const Duration(seconds: 1));
          });

        case 'launch':
          await _requireConnected(connectedDevice, () async {
            await repo.sendCommand(const RobotCommand.launch());
            print('Sent: LAUNCH');
            await Future.delayed(const Duration(seconds: 1));
          });

        case 'stop':
          await _requireConnected(connectedDevice, () async {
            await repo.sendCommand(const RobotCommand.stop());
            print('Sent: STOP');
            await Future.delayed(const Duration(seconds: 1));
          });

        case 'state':
          print('Last known: $lastState');

        case 'quit':
        case 'exit':
          running = false;

        default:
          print("Unknown command '$cmd'. Type 'help' for the list.");
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  await stateSub.cancel();
  await connSub.cancel();
  repo.dispose();
  mock.dispose();
  print('Bye!');
  exit(0);
}

List<BleDevice> _lastScan = [];

Future<void> _requireConnected(
  BleDevice? device,
  Future<void> Function() action,
) async {
  if (device == null) {
    print("Not connected. Run 'scan' then 'connect <index>' first.");
    return;
  }
  await action();
}

int? _parseIntArg(String? raw, String hint) {
  if (raw == null) {
    print('Missing value. Expected $hint.');
    return null;
  }
  final v = int.tryParse(raw);
  if (v == null) {
    print("'$raw' is not a valid integer. Expected $hint.");
    return null;
  }
  return v;
}

void _printHelp() {
  print('''
Commands:
  scan                 Scan for nearby robots (3s window)
  connect <index>       Connect to a device from the last scan
  disconnect            Disconnect from the current robot
  top <0-100>            Set top motor speed
  bottom <0-100>         Set bottom motor speed
  vertical <-45..45>     Set vertical angle
  horizontal <-180..180> Set horizontal angle
  launch                 Fire the launch command
  stop                   Fire the stop command
  state                  Reminder of where live telemetry prints
  help                   Show this list
  quit / exit            Exit the CLI
''');
}
