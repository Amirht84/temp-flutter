// ============================================================
// FILE: lib/src/ble/ble_constants.dart
// All UUIDs and protocol limits live here so every layer can
// import them without creating circular dependencies.
// ============================================================

enum Modes { IDLE, MANUAL, SEQUENCE, RANDOM, STOP, SMART }

/// UUID constants for the robot BLE service / characteristics.
class BleConstants {
  BleConstants._();

  // ── Service ────────────────────────────────────────────────
  static const String robotServiceUuid = 'bb400001-2fe3-48bc-baa7-fb92a0611f6a';

  // ── Characteristics ────────────────────────────────────────
  /// Write commands TO the robot.
  static const String RPM = 'bb400002-2fe3-48bc-baa7-fb92a0611f6a'; // set RPM

  /// Notify characteristic for robot status updates.
  static const String Mode =
      'bb400003-2fe3-48bc-baa7-fb92a0611f6a'; // Horizontal angle

  static const String Vangle =
      'bb400004-2fe3-48bc-baa7-fb92a0611f6a'; // Vertical angle

  static const String Shoot =
      'bb400005-2fe3-48bc-baa7-fb92a0611f6a'; // shooting

  static const String UNUSED = 'bb400006-2fe3-48bc-baa7-fb92a0611f6a'; // stop

  static const String Movement =
      'bb400007-2fe3-48bc-baa7-fb92a0611f6a'; // Movement
  // ── Motor / angle limits ────────────────────────────────────
  static const int motorSpeedMin = 0;
  static const int motorSpeedMax = 100; // percent (top & bottom RPM)

  static const double verticalAngleMin = 10; // degrees
  static const double verticalAngleMax = 45; // degrees

  static const double horizontalAngleMin = -180;
  static const double horizontalAngleMax = 180; // degrees

  // Joystick axes are normalised, same as a typical game-controller stick.
  static const double joystickMin = -1.0;
  static const double joystickMax = 1.0;

  // ── Scan timeout ───────────────────────────────────────────
  static const Duration scanTimeout = Duration(seconds: 10);
}
