import 'robot_command.dart';
import 'ble_service.dart';

class RobotController {
  final BleService _ble;

  RobotController(this._ble);

  int upWheelSpeed = 50;
  int downWheelSpeed = 50;
  int horizontalAngle = 90;
  int verticalAngle = 45;

  BleService get ble => _ble;

  Future<void> launch() async {
    final cmd = RobotCommand(
      upWheelSpeed: upWheelSpeed,
      downWheelSpeed: downWheelSpeed,
      horizontalAngle: horizontalAngle,
      verticalAngle: verticalAngle,
    );
    await _ble.writeCommand(cmd.toBytes());
  }

  /// Stop: send a stop command (all zeros, with 0xBB marker).
  Future<void> stop() async {
    await _ble.writeCommand([0xBB, 0, 0, 0, 0]);
  }

  void dispose() {
    _ble.dispose();
  }
}
