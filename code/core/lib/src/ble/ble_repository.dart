// ============================================================
// FILE: lib/src/ble/ble_repository.dart
// Repository layer: converts raw BLE bytes into domain objects
// and exposes a clean async API to the ViewModel.
// The ViewModel NEVER calls BleService directly.
// ============================================================

import 'dart:async';

import '../models/robot_command.dart';
import '../models/robot_state.dart';
import 'ble_constants.dart';
import 'ble_device.dart';
import 'ble_service.dart';

/// Mediates between [BleService] (hardware) and the ViewModel
/// (business logic).
///
/// Responsibilities:
///  • Encodes [RobotCommand] → byte arrays.
///  • Decodes status byte arrays → [RobotState].
///  • Manages scan / connection life-cycle.
class BleRepository {
  BleRepository({required BleService bleService}) : _ble = bleService;

  final BleService _ble;

  // ── Internal state ─────────────────────────────────────────
  final _robotStateController = StreamController<RobotState>.broadcast();

  StreamSubscription<List<int>>? _statusSub;

  // ── Public streams ─────────────────────────────────────────

  /// Latest robot telemetry decoded from BLE notifications.
  Stream<RobotState> get robotStateStream => _robotStateController.stream;

  /// Mirrors the underlying BLE connection state.
  Stream<bool> get connectionStream => _ble.connectionState;

  // ── Scanning ───────────────────────────────────────────────

  /// Returns a stream of nearby [BleDevice]s.
  Stream<BleDevice> scanForRobots() =>
      _ble.scanForDevices(timeout: BleConstants.scanTimeout);

  Future<void> stopScan() => _ble.stopScan();

  // ── Connection ─────────────────────────────────────────────

  /// Connects to [device] and starts listening for status
  /// notifications.
  Future<void> connectToRobot(BleDevice device) async {
    await _ble.connect(device);
    _startListeningToStatus();
  }

  /// Disconnects and cleans up subscriptions.
  Future<void> disconnectFromRobot() async {
    await _statusSub?.cancel();
    _statusSub = null;
    await _ble.disconnect();
  }

  // ── Commands ───────────────────────────────────────────────

  /// Encodes [command] and writes it over BLE.
  Future<void> sendCommand(RobotCommand command) async {
    final bytes = _encodeCommand(command);
    await _ble.writeCommand(bytes);
  }

  // ── Private helpers ────────────────────────────────────────

  void _startListeningToStatus() {
    _statusSub?.cancel();
    _statusSub = _ble.statusNotifications.listen((bytes) {
      final state = _decodeState(bytes);
      if (state != null) _robotStateController.add(state);
    }, onError: _robotStateController.addError);
  }

  /// Encodes a [RobotCommand] into a compact byte frame:
  ///
  ///  [ CMD_TYPE | VALUE_HIGH | VALUE_LOW | CHECKSUM ]
  ///
  /// CMD_TYPE values:
  ///  0x01 – top motor speed
  ///  0x02 – bottom motor speed
  ///  0x03 – vertical angle   (offset by +45 to keep positive)
  ///  0x04 – horizontal angle (offset by +180)
  ///  0x05 – launch
  ///  0x06 – stop
  List<int> _encodeCommand(RobotCommand command) {
    int cmdType;
    int value;

    switch (command.type) {
      case CommandType.topMotorSpeed:
        cmdType = 0x01;
        value = command.value.clamp(
          BleConstants.motorSpeedMin,
          BleConstants.motorSpeedMax,
        );
      case CommandType.bottomMotorSpeed:
        cmdType = 0x02;
        value = command.value.clamp(
          BleConstants.motorSpeedMin,
          BleConstants.motorSpeedMax,
        );
      case CommandType.verticalAngle:
        cmdType = 0x03;
        // Shift negative range to 0-based for a single unsigned byte.
        value =
            (command.value.clamp(
              BleConstants.verticalAngleMin,
              BleConstants.verticalAngleMax,
            ) +
            45);
      case CommandType.horizontalAngle:
        cmdType = 0x04;
        value =
            (command.value.clamp(
              BleConstants.horizontalAngleMin,
              BleConstants.horizontalAngleMax,
            ) +
            180);
      case CommandType.launch:
        cmdType = 0x05;
        value = 0x00;
      case CommandType.stop:
        cmdType = 0x06;
        value = 0x00;
    }

    final high = (value >> 8) & 0xFF;
    final low = value & 0xFF;
    final checksum = (cmdType ^ high ^ low) & 0xFF;
    return [cmdType, high, low, checksum];
  }

  /// Decodes a 4-byte status frame from the robot.
  ///
  ///  [ IS_RUNNING | TOP_SPEED | BOTTOM_SPEED | CHECKSUM ]
  RobotState? _decodeState(List<int> bytes) {
    if (bytes.length < 4) return null;

    final checksum = (bytes[0] ^ bytes[1] ^ bytes[2]) & 0xFF;
    if (checksum != bytes[3]) return null; // discard corrupt frame

    return RobotState(
      isRunning: bytes[0] == 0x01,
      topMotorSpeed: bytes[1],
      bottomMotorSpeed: bytes[2],
    );
  }

  /// Frees stream resources.
  void dispose() {
    _statusSub?.cancel();
    _robotStateController.close();
  }
}
