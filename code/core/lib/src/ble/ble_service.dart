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

  /// Connects to [device] and resolves when the link is ready.
  Future<void> connect(BleDevice device);

  /// Disconnects from the currently connected device.
  Future<void> disconnect();

  /// Stream that emits `true` when connected, `false` when not.
  Stream<bool> get connectionState;

  // ── Communication ──────────────────────────────────────────

  /// Writes [data] bytes to the command characteristic.
  Future<void> writeCommand(List<int> data);

  /// Subscribes to status notifications from the robot.
  Stream<List<int>> get statusNotifications;
}
