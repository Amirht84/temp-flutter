// ============================================================
// FILE: lib/src/ble/ble_constants.dart
// All UUIDs and protocol limits live here so every layer can
// import them without creating circular dependencies.
// ============================================================

/// UUID constants for the robot BLE service / characteristics.
class BleConstants {
  BleConstants._();

  // ── Service ────────────────────────────────────────────────
  static const String robotServiceUuid = '0000FFE0-0000-1000-8000-00805F9B34FB';

  // ── Characteristics ────────────────────────────────────────
  /// Write commands TO the robot.
  static const String commandCharUuid = '0000FFE1-0000-1000-8000-00805F9B34FB';

  /// Notify characteristic for robot status updates.
  static const String statusCharUuid = '0000FFE2-0000-1000-8000-00805F9B34FB';

  // ── Motor / angle limits ────────────────────────────────────
  static const int motorSpeedMin = 0;
  static const int motorSpeedMax = 100; // percent

  static const int verticalAngleMin = -45;
  static const int verticalAngleMax = 45; // degrees

  static const int horizontalAngleMin = -180;
  static const int horizontalAngleMax = 180; // degrees

  // ── Scan timeout ───────────────────────────────────────────
  static const Duration scanTimeout = Duration(seconds: 10);
}
