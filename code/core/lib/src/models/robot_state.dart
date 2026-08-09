// ============================================================
// FILE: lib/src/models/robot_state.dart
// Immutable snapshot of what the robot reported back over BLE.
// ============================================================

/// Decoded robot telemetry received via BLE status notifications.
class RobotState {
  const RobotState({
    required this.isRunning,
    required this.topMotorSpeed,
    required this.bottomMotorSpeed,
  });

  /// `true` when the robot is actively launching.
  final bool isRunning;

  /// Top motor speed 0–100 %.
  final int topMotorSpeed;

  /// Bottom motor speed 0–100 %.
  final int bottomMotorSpeed;

  /// Sentinel value before any telemetry has arrived.
  static const RobotState initial = RobotState(
    isRunning: false,
    topMotorSpeed: 0,
    bottomMotorSpeed: 0,
  );

  RobotState copyWith({
    bool? isRunning,
    int? topMotorSpeed,
    int? bottomMotorSpeed,
  }) => RobotState(
    isRunning: isRunning ?? this.isRunning,
    topMotorSpeed: topMotorSpeed ?? this.topMotorSpeed,
    bottomMotorSpeed: bottomMotorSpeed ?? this.bottomMotorSpeed,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RobotState &&
          other.isRunning == isRunning &&
          other.topMotorSpeed == topMotorSpeed &&
          other.bottomMotorSpeed == bottomMotorSpeed;

  @override
  int get hashCode => Object.hash(isRunning, topMotorSpeed, bottomMotorSpeed);

  @override
  String toString() =>
      'RobotState(running: $isRunning, top: $topMotorSpeed, '
      'bottom: $bottomMotorSpeed)';
}
