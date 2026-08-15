// ============================================================
// FILE: test/ble_repository_mock_test.dart
// Automated regression test for the scan/connect flow fixed in
// BleRepository: scanForRobots() must stream every discovered
// device (so the UI can show a full list), and connectToRobot()
// must resolve once the connection attempt completes, with
// connectionStream reflecting the resulting state.
//
// Run with (from code/core):  flutter test test/ble_repository_mock_test.dart
// ============================================================

import 'package:flutter_test/flutter_test.dart';

import '../lib/src/ble/ble_device.dart';
import '../lib/src/ble/ble_repository.dart';
import '../lib/src/ble/mock_ble_service.dart';

void main() {
  test('scanForRobots streams every discovered device', () async {
    final mock = MockBleService();
    final repo = BleRepository(bleService: mock);
    addTearDown(() {
      repo.dispose();
      mock.dispose();
    });

    final devices = await repo
        .scanForRobots(timeout: const Duration(milliseconds: 700))
        .toList();

    expect(devices.length, 2);
    expect(devices.map((d) => d.name), contains('Tennis Robot'));
  });

  test(
    'connectToRobot resolves and connectionStream reflects it',
    () async {
      final mock = MockBleService();
      final repo = BleRepository(bleService: mock);
      addTearDown(() {
        repo.dispose();
        mock.dispose();
      });

      const device = BleDevice(id: '00:11', name: 'Robot', rssi: -40);

      final statesExpectation = expectLater(
        repo.connectionStream,
        emitsInOrder([true, false]),
      );

      await repo.connectToRobot(device);
      await repo.disconnectFromRobot();

      await statesExpectation;
    },
  );
}
