// ============================================================
// FILE: test/real_robot_cli.dart
// A REAL command-line harness — same commands as
// `core_test.dart`, but backed by `FlutterBluePlusService`
// instead of `MockBleService`, so it talks to actual robot
// hardware over Bluetooth Low Energy.
//
// This still needs the Flutter *engine* (flutter_blue_plus uses
// platform channels), so it can't be run with plain `dart run`.
// Run it with `flutter run`, targeting a platform that:
//   1. has a real Bluetooth radio, and
//   2. shares its stdin/stdout with this terminal, so
//      `stdin.readLineSync()` below actually works.
//
// That means: desktop only (Linux/macOS natively support
// flutter_blue_plus; Windows needs the extra
// `flutter_blue_plus_windows` package swapped in — see
// README_REAL_TEST.md). On Android/iOS, `flutter run` does NOT
// forward this terminal's stdin into the app process, so this
// particular file won't accept input there — use
// `debug_robot_screen.dart` (a real UI) for phone testing
// instead.
//
//   flutter run -d linux  -t test/real_robot_cli.dart
//   flutter run -d macos  -t test/real_robot_cli.dart
//   flutter run -d windows -t test/real_robot_cli.dart   (after adding Windows BLE support)
// ============================================================

import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../lib/src/ble/ble_device.dart';
import '../lib/src/ble/ble_repository.dart';
import '../lib/src/ble/flutter_blue_plus_service.dart';
import '../lib/src/models/robot_state.dart';

Future<void> main() async {
  // flutter_blue_plus talks to the platform over method/event
  // channels, which requires the Flutter engine's binary
  // messenger to be wired up first — even though we never call
  // runApp().
  WidgetsFlutterBinding.ensureInitialized();

  final ble = FlutterBluePlusService();
  final repo = BleRepository(bleService: ble);

  BleDevice? connectedDevice;
  RobotState lastState = RobotState.initial;

  final stateSub = repo.robotStateStream.listen((state) {
    lastState = state;
    print('📡 state: $state');
  });
  final connSub = repo.connectionStream.listen((connected) {
    print(connected ? '✅ connection established' : '⚠️  connection lost');
  });

  print('=== Tennis Robot REAL Hardware CLI ===');
  print('Talking to real BLE hardware via FlutterBluePlusService.');
  print("Type 'help' for commands.\n");

  try {
    print('Checking Bluetooth adapter...');
    await ble.ensureBluetoothOn();
    print('Bluetooth is on.\n');
  } catch (e) {
    print('❌ $e');
    print('Fix Bluetooth / permissions, then re-run.');
    await stateSub.cancel();
    await connSub.cancel();
    repo.dispose();
    ble.dispose();
    exit(1);
  }

  var running = true;
  while (running) {
    stdout.write('> ');
    final line = stdin.readLineSync()?.trim() ?? '';
    if (line.isEmpty) continue;
    final parts = line.split(RegExp(r'\s+'));
    final cmd = parts.first.toLowerCase();
    final args = parts.skip(1).toList();

    try {
      switch (cmd) {
        case 'help':
          _printHelp();

        case 'scan':
          print('Scanning for ${BleScanSeconds}s...');
          final devices = <BleDevice>[];
          await for (final d in repo.scanForRobots().timeout(
            Duration(seconds: BleScanSeconds),
            onTimeout: (s) => s.close(),
          )) {
            devices.add(d);
            print('  [${devices.length}] ${d.name} (${d.id})  rssi=${d.rssi}');
          }
          if (devices.isEmpty) {
            print(
              'No devices found. Confirm the robot is powered on, '
              'advertising, and in range.',
            );
          } else {
            print("Use 'connect <index>' to connect, e.g. 'connect 1'.");
            _lastScan = devices;
          }

        case 'connect':
          if (args.isEmpty || _lastScan.isEmpty) {
            print("Run 'scan' first, then 'connect <index>'.");
            break;
          }
          final idx = int.tryParse(args[0]);
          if (idx == null || idx < 1 || idx > _lastScan.length) {
            print('Invalid index.');
            break;
          }
          connectedDevice = _lastScan[idx - 1];
          print('Connecting to ${connectedDevice.name}...');
          await repo.connectToRobot(connectedDevice);
          print('Connected.');

        case 'disconnect':
          await repo.disconnectFromRobot();
          connectedDevice = null;
          print('Disconnected.');

        case 'rpm':
          await _requireConnected(connectedDevice, () async {
            final top = _parseIntArg(args, 0, 'top RPM (0-100)');
            final bottom = _parseIntArg(args, 1, 'bottom RPM (0-100)');
            if (top == null || bottom == null) return;
            await repo.setRpm(top, bottom);
            print('Sent: RPM top=$top bottom=$bottom');
          });

        case 'angleh':
          await _requireConnected(connectedDevice, () async {
            final deg = _parseDoubleArg(args, 0, 'degrees (-180..180)');
            if (deg == null) return;
            await repo.setAngleH(deg);
            print('Sent: angle H = $deg°');
          });

        case 'anglev':
          await _requireConnected(connectedDevice, () async {
            final deg = _parseDoubleArg(args, 0, 'degrees (-45..45)');
            if (deg == null) return;
            await repo.setAngleV(deg);
            print('Sent: angle V = $deg°');
          });

        case 'joystick':
          await _requireConnected(connectedDevice, () async {
            final x = _parseDoubleArg(args, 0, 'x (-1.0..1.0)');
            final y = _parseDoubleArg(args, 1, 'y (-1.0..1.0)');
            if (x == null || y == null) return;
            await repo.joystick(x, y);
            print('Sent: joystick x=$x y=$y');
          });

        case 'shoot':
          await _requireConnected(connectedDevice, () async {
            await repo.shoot();
            print('Sent: SHOOT');
          });

        case 'stop':
          await _requireConnected(connectedDevice, () async {
            await repo.stop();
            print('Sent: STOP');
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

  if (connectedDevice != null) {
    print('Disconnecting before exit...');
    await repo.disconnectFromRobot();
  }
  await stateSub.cancel();
  await connSub.cancel();
  repo.dispose();
  ble.dispose();
  print('Bye!');
  exit(0);
}

/// Scan window, in seconds, for the `scan` command.
const int BleScanSeconds = 6;

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

int? _parseIntArg(List<String> args, int index, String hint) {
  if (index >= args.length) {
    print('Missing value. Expected $hint.');
    return null;
  }
  final v = int.tryParse(args[index]);
  if (v == null) {
    print("'${args[index]}' is not a valid integer. Expected $hint.");
    return null;
  }
  return v;
}

double? _parseDoubleArg(List<String> args, int index, String hint) {
  if (index >= args.length) {
    print('Missing value. Expected $hint.');
    return null;
  }
  final v = double.tryParse(args[index]);
  if (v == null) {
    print("'${args[index]}' is not a valid number. Expected $hint.");
    return null;
  }
  return v;
}

void _printHelp() {
  print('''
Commands (sent to REAL hardware over BLE):
  scan                     Scan for nearby robots (${BleScanSeconds}s window)
  connect <index>          Connect to a device from the last scan
  disconnect               Disconnect from the current robot
  rpm <top> <bottom>       Set top & bottom motor RPM (0-100)
  angleh <degrees>         Set horizontal angle (-180..180)
  anglev <degrees>         Set vertical angle (-45..45)
  joystick <x> <y>         Drive via joystick axes (-1.0..1.0)
  shoot                    Fire the launcher
  stop                     Stop the launcher / motors
  state                    Print the last-known commanded state
  help                     Show this list
  quit / exit              Exit the CLI
''');
}
