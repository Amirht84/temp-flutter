// ============================================================
// FILE: lib/src/models/robot_state.dart
// Immutable snapshot of the last setpoints sent to the robot.
//
// NOTE: the current BLE protocol (BleConstants.RPM / Hangle /
// Vangle / Shoot / Stop / Movement) is write-only — the robot
// does not notify telemetry back. This state is therefore the
// last value the app *commanded*, tracked locally by
// BleRepository, so the UI has something to bind to (e.g. to
// show current setpoints or disable a duplicate command).
// ============================================================

/// Last-known commanded state of the robot.
class RobotState {
  const RobotState({
    required this.isRunning,
    required this.topRpm,
    required this.bottomRpm,
    required this.angleH,
    required this.angleV,
    required this.joystickX,
    required this.joystickY,
  });

  /// `true` after [BleRepository.shoot], `false` after [BleRepository.stop].
  final bool isRunning;

  /// Last commanded top motor RPM.
  final int topRpm;

  /// Last commanded bottom motor RPM.
  final int bottomRpm;

  /// Last commanded horizontal (pan) angle, in degrees.
  final double angleH;

  /// Last commanded vertical (tilt) angle, in degrees.
  final double angleV;

  /// Last commanded joystick X axis (-1.0..1.0).
  final double joystickX;

  /// Last commanded joystick Y axis (-1.0..1.0).
  final double joystickY;

  /// Sentinel value before any command has been sent.
  static const RobotState initial = RobotState(
    isRunning: false,
    topRpm: 0,
    bottomRpm: 0,
    angleH: 0,
    angleV: 0,
    joystickX: 0,
    joystickY: 0,
  );

  RobotState copyWith({
    bool? isRunning,
    int? topRpm,
    int? bottomRpm,
    double? angleH,
    double? angleV,
    double? joystickX,
    double? joystickY,
  }) => RobotState(
    isRunning: isRunning ?? this.isRunning,
    topRpm: topRpm ?? this.topRpm,
    bottomRpm: bottomRpm ?? this.bottomRpm,
    angleH: angleH ?? this.angleH,
    angleV: angleV ?? this.angleV,
    joystickX: joystickX ?? this.joystickX,
    joystickY: joystickY ?? this.joystickY,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RobotState &&
          other.isRunning == isRunning &&
          other.topRpm == topRpm &&
          other.bottomRpm == bottomRpm &&
          other.angleH == angleH &&
          other.angleV == angleV &&
          other.joystickX == joystickX &&
          other.joystickY == joystickY;

  @override
  int get hashCode => Object.hash(
    isRunning,
    topRpm,
    bottomRpm,
    angleH,
    angleV,
    joystickX,
    joystickY,
  );

  @override
  String toString() =>
      'RobotState(running: $isRunning, rpm: $topRpm/$bottomRpm, '
      'angleH: $angleH°, angleV: $angleV°, '
      'joystick: ($joystickX, $joystickY))';
}
