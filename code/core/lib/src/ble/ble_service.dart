// ============================================================
// FILE: lib/src/ble/ble_service.dart
// Abstract contract for BLE hardware access.
// A real flutter_blue_plus (or similar) adapter implements
// this interface; a mock version is used in tests.
// ============================================================

import 'ble_device.dart';

/// Low-level BLE hardware interface.
///
/// Implementations wrap a concrete BLE plugin
/// (e.g. flutter_blue_plus) and translate its API into the
/// types defined in this library.
abstract class BleService {
  // ── Scanning ───────────────────────────────────────────────

  /// Emits [BleDevice]s as they are discovered.
  Stream<BleDevice> scanForDevices({Duration? timeout});

  /// Stops an in-progress scan.
  Future<void> stopScan();

  // ── Connection ─────────────────────────────────────────────

  /// Connects to [device] and resolves when the link is ready,
  /// i.e. once every characteristic UUID in `BleConstants` has
  /// been discovered on the robot's GATT service.
  Future<void> connect(BleDevice device);

  /// Disconnects from the currently connected device.
  Future<void> disconnect();

  /// Stream that emits `true` when connected, `false` when not.
  Stream<bool> get connectionState;

  // ── Communication ──────────────────────────────────────────

  /// Writes [data] bytes to the characteristic identified by
  /// [characteristicUuid] (one of the UUID constants declared in
  /// `BleConstants`, e.g. `BleConstants.RPM`).
  Future<void> writeCharacteristic(String characteristicUuid, List<int> data);
}
