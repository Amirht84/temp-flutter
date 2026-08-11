// ============================================================
// FILE: lib/src/models/robot_command.dart
// Immutable value object representing a single UI action.
//
// Each command targets exactly one BLE characteristic (see
// BleConstants): RPM, Hangle, Vangle, Shoot, Stop, Movement.
// ============================================================

/// The six control actions exposed by the robot UI.
enum CommandType { rpm, angleH, angleV, shoot, stop, joystick }

/// An immutable command issued from the ViewModel to the robot.
///
/// Only the fields relevant to [type] are meaningful — e.g. a
/// [CommandType.rpm] command uses [intA]/[intB], a
/// [CommandType.angleH] command uses [doubleA], etc.
class RobotCommand {
  const RobotCommand._(
    this.type, {
    this.intA = 0,
    this.intB = 0,
    this.doubleA = 0,
    this.doubleB = 0,
  });

  /// Which parameter is being set.
  final CommandType type;

  /// First integer payload (e.g. top RPM).
  final int intA;

  /// Second integer payload (e.g. bottom RPM).
  final int intB;

  /// First floating-point payload (e.g. angle, joystick X).
  final double doubleA;

  /// Second floating-point payload (e.g. joystick Y).
  final double doubleB;

  // ── Named constructors (self-documenting API) ───────────────

  /// Sets the top & bottom flywheel motor RPM.
  const RobotCommand.rpm(int topRpm, int bottomRpm)
    : this._(CommandType.rpm, intA: topRpm, intB: bottomRpm);

  /// Sets the horizontal (pan) angle, in degrees.
  const RobotCommand.angleH(double degrees)
    : this._(CommandType.angleH, doubleA: degrees);

  /// Sets the vertical (tilt) angle, in degrees.
  const RobotCommand.angleV(double degrees)
    : this._(CommandType.angleV, doubleA: degrees);

  /// Fires the launcher.
  const RobotCommand.shoot() : this._(CommandType.shoot);

  /// Stops the launcher / motors.
  const RobotCommand.stop() : this._(CommandType.stop);

  /// Drives the robot via a normalised 2-axis joystick (-1.0..1.0).
  const RobotCommand.joystick(double x, double y)
    : this._(CommandType.joystick, doubleA: x, doubleB: y);

  @override
  String toString() {
    switch (type) {
      case CommandType.rpm:
        return 'RobotCommand.rpm(top: $intA, bottom: $intB)';
      case CommandType.angleH:
        return 'RobotCommand.angleH($doubleA°)';
      case CommandType.angleV:
        return 'RobotCommand.angleV($doubleA°)';
      case CommandType.shoot:
        return 'RobotCommand.shoot()';
      case CommandType.stop:
        return 'RobotCommand.stop()';
      case CommandType.joystick:
        return 'RobotCommand.joystick(x: $doubleA, y: $doubleB)';
    }
  }
}
