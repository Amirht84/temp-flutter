// ============================================================
// FILE: lib/src/models/robot_command.dart
// Immutable value object representing a single UI action.
// ============================================================

/// The six control actions exposed by the robot UI.
enum CommandType {
  topMotorSpeed,
  bottomMotorSpeed,
  verticalAngle,
  horizontalAngle,
  launch,
  stop,
}

/// An immutable command issued from the ViewModel to the robot.
class RobotCommand {
  const RobotCommand({required this.type, this.value = 0});

  /// Which parameter is being set.
  final CommandType type;

  /// Numeric payload (speed %, angle °, or 0 for launch/stop).
  final int value;

  // ── Named constructors (self-documenting API) ───────────────

  const RobotCommand.topMotorSpeed(int speed)
    : this(type: CommandType.topMotorSpeed, value: speed);

  const RobotCommand.bottomMotorSpeed(int speed)
    : this(type: CommandType.bottomMotorSpeed, value: speed);

  const RobotCommand.verticalAngle(int degrees)
    : this(type: CommandType.verticalAngle, value: degrees);

  const RobotCommand.horizontalAngle(int degrees)
    : this(type: CommandType.horizontalAngle, value: degrees);

  const RobotCommand.launch() : this(type: CommandType.launch, value: 0);

  const RobotCommand.stop() : this(type: CommandType.stop, value: 0);

  @override
  String toString() => 'RobotCommand(type: $type, value: $value)';
}
