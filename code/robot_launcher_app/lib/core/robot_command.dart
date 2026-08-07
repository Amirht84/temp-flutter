class RobotCommand {
  final int upWheelSpeed; // 0–100
  final int downWheelSpeed; // 0–100
  final int horizontalAngle; // 0–180
  final int verticalAngle; // 0–90

  const RobotCommand({
    required this.upWheelSpeed,
    required this.downWheelSpeed,
    required this.horizontalAngle,
    required this.verticalAngle,
  });

  /// Encodes to 5 bytes: [0xAA, upSpeed, downSpeed, hAngle, vAngle]
  /// 0xAA is a start/sync byte so the robot firmware can frame packets.
  List<int> toBytes() => [
    0xAA,
    upWheelSpeed,
    downWheelSpeed,
    horizontalAngle,
    verticalAngle,
  ];
}
