// ============================================================
// FILE: example/core_example.dart
// Minimal usage example of the core robot-control API, backed
// by MockBleService so it runs with no real hardware.
//
// Run with (from code/core):
//   dart run example/core_example.dart
// ============================================================

import '../lib/src/ble/ble_repository.dart';
import '../lib/src/ble/mock_ble_service.dart';

Future<void> main() async {
  final ble = MockBleService(verbose: true);
  final repo = BleRepository(bleService: ble);

  repo.robotStateStream.listen((state) => print('state -> $state'));

  // Scanning is optional in this example — MockBleService's fake
  // devices are deterministic, so we just connect directly.
  final device = await repo.scanForRobots().first;
  await repo.connectToRobot(device);

  await repo.setRpm(80, 80); // top/bottom motor RPM
  await repo.setAngleH(15.0); // pan 15° right
  await repo.setAngleV(-5.0); // tilt 5° down
  await repo.joystick(0.5, -1.0); // drive: half-right, full-reverse
  await repo.shoot();
  await Future.delayed(const Duration(seconds: 1));
  await repo.stop();

  await repo.disconnectFromRobot();
  repo.dispose();
  ble.dispose();
}
