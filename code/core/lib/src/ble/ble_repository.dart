// ============================================================
// FILE: lib/src/ble/ble_repository.dart
// Repository layer: converts domain calls into raw BLE writes
// on the correct characteristic, and exposes a clean async API
// to the ViewModel. The ViewModel NEVER calls BleService
// directly.
// ============================================================

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // added for Bluetooth state
import 'package:permission_handler/permission_handler.dart'; // added for permissions

import '../models/robot_state.dart';
import 'ble_constants.dart';
import 'ble_device.dart';
import 'ble_service.dart';
import 'flutter_blue_plus_service.dart';

/// Mediates between [BleService] (hardware) and the ViewModel
/// (business logic).
///
/// Responsibilities:
///  • Encodes each control action into the byte frame expected
///    by its own BLE characteristic (see `BleConstants`).
///  • Tracks the last-commanded [RobotState] locally, since the
///    current protocol is fluwrite-only (no telemetry notify).
///  • Manages scan / connection life-cycle.
class BleRepository {
  final _ble = FlutterBluePlusService();

  // ── Internal state ─────────────────────────────────────────
  final _robotStateController = StreamController<RobotState>.broadcast();
  RobotState _state = RobotState.initial;

  // ── Public streams ─────────────────────────────────────────

  /// Last-known commanded state (see [RobotState] docs — this is
  /// NOT telemetry read back from the robot).
  Stream<RobotState> get robotStateStream => _robotStateController.stream;

  /// Current cached state, without needing to subscribe.
  RobotState get currentState => _state;

  /// Mirrors the underlying BLE connection state.
  Stream<bool> get connectionStream => _ble.connectionState;

  BleService get Ble => _ble;

  // ── Permissions & Bluetooth state ─────────────────────────

  /// Requests the permissions required for BLE scanning and connection.
  /// Returns `true` if all required permissions are granted, otherwise `false`.
  Future<bool> requestPermissions() async {
    final status = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    // On Android, location permission is often required for BLE scanning.
    // You can decide whether to require it as well.
    final bluetoothGranted =
        status[Permission.bluetoothScan]!.isGranted &&
        status[Permission.bluetoothConnect]!.isGranted;

    // Optionally also check location (uncomment if needed):
    // final locationGranted = status[Permission.location]!.isGranted;
    // return bluetoothGranted && locationGranted;
    return bluetoothGranted;
  }

  /// Checks whether the device's Bluetooth adapter is powered on.
  Future<bool> isBluetoothOn() async {
    return await FlutterBluePlus.isOn;
  }

  /// Convenience method that ensures both permissions are granted
  /// and Bluetooth is on. Returns `true` only if both conditions are met.
  Future<bool> ensurePermissionsAndBluetooth() async {
    final permissionsOk = await requestPermissions();
    if (!permissionsOk) return false;
    return await isBluetoothOn();
  }

  // ── Scanning ───────────────────────────────────────────────
  /// Scans for nearby devices and returns the first [BleDevice] matching
  /// the target service UUID defined in [BleConstants.robotServiceUuid].
  ///
  /// Returns `null` if no matching device is found before the scan completes.
  Future<BleDevice?> scanForRobots() async {
    try {
      final device = await _ble
          .scanForDevices(timeout: BleConstants.scanTimeout)
          .firstWhere((device) => device.id == BleConstants.robotServiceUuid);
      return device;
    } catch (_) {
      // Returns null if firstWhere times out or completes without finding a match
      return null;
    }
  }

  Future<void> stopScan() => _ble.stopScan();

  // ── Connection ─────────────────────────────────────────────

  /// Connects to [device] and returns a stream notifying connection state changes.
  Stream<bool> connectToRobot(BleDevice device) {
    _ble.connect(device);
    return connectionStream;
  }

  /// Disconnects and resets the cached state.
  Future<void> disconnectFromRobot() async {
    await _ble.disconnect();
    _updateState(RobotState.initial);
  }

  // ── Commands (one per BLE characteristic) ───────────────────

  /// Sets the top & bottom flywheel motor RPM.
  ///
  /// Frame written to `BleConstants.RPM`:
  ///  [ TOP_HIGH | TOP_LOW | BOTTOM_HIGH | BOTTOM_LOW | CHECKSUM ]
  /// where TOP/BOTTOM are big-endian uint16, clamped to
  /// `[motorSpeedMin, motorSpeedMax]`.
  Future<void> setRpm(int topRpm, int bottomRpm) async {
    final top = topRpm
        .clamp(BleConstants.motorSpeedMin, BleConstants.motorSpeedMax)
        .toInt();

    final bottom = bottomRpm
        .clamp(BleConstants.motorSpeedMin, BleConstants.motorSpeedMax)
        .toInt();

    final payload = [..._intToBytes(top), ..._intToBytes(bottom)];

    await _writeFrame(BleConstants.RPM, payload);

    _updateState(_state.copyWith(topRpm: top, bottomRpm: bottom));
  }

  /// Sets the horizontal (pan) angle, in degrees.
  ///
  /// Frame written to `BleConstants.Hangle`:
  ///  [ FLOAT32 (big-endian) | CHECKSUM ]
  // Future<void> setAngleH(double degrees) async {
  //   final clamped = degrees
  //       .clamp(BleConstants.horizontalAngleMin, BleConstants.horizontalAngleMax)
  //       .toDouble();
  //   await _writeFrame(BleConstants.Hangle, _floatToBytes(clamped));
  //   _updateState(_state.copyWith(angleH: clamped));
  // }

  /// Sets the vertical (tilt) angle, in degrees.
  ///
  /// Frame written to `BleConstants.Vangle`:
  ///  [ FLOAT32 (big-endian) | CHECKSUM ]
  Future<void> setAngleV(double degrees) async {
    final clamped = degrees
        .clamp(BleConstants.verticalAngleMin, BleConstants.verticalAngleMax)
        .toDouble();
    await _writeFrame(BleConstants.Vangle, _floatToBytes(clamped));
    _updateState(_state.copyWith(angleV: clamped));
  }

  /// Fires the launcher. Written as an acknowledged write since
  /// it's safety-critical (see `BleService.writeCharacteristic`
  /// implementations).
  Future<void> shoot() async {
    await _ble.writeCharacteristic(BleConstants.Shoot, const [0x01]);
    _updateState(_state.copyWith(isRunning: true));
  }

  /// Stops the launcher / motors. Acknowledged write, same as
  /// [shoot].
  Future<void> stop() async {
    await _ble.writeCharacteristic(BleConstants.UNUSED, const [0x01]);
    _updateState(_state.copyWith(isRunning: false, topRpm: 0, bottomRpm: 0));
  }

  /// Drives the robot via a normalised 2-axis joystick, each axis
  /// clamped to `[joystickMin, joystickMax]` (-1.0..1.0).
  ///
  /// Frame written to `BleConstants.Movement`:
  ///  [ X_FLOAT32 | Y_FLOAT32 (both big-endian) | CHECKSUM ]
  Future<void> joystick(double x, double y, double angleH) async {
    final cx = x
        .clamp(BleConstants.joystickMin, BleConstants.joystickMax)
        .toDouble();
    final cy = y
        .clamp(BleConstants.joystickMin, BleConstants.joystickMax)
        .toDouble();

    final ch = angleH
        .clamp(BleConstants.horizontalAngleMin, BleConstants.horizontalAngleMax)
        .toDouble();
    final payload = [
      ..._floatToBytes(cx),
      ..._floatToBytes(cy),
      ..._floatToBytes(ch),
    ];
    await _writeFrame(BleConstants.Movement, payload);
    _updateState(_state.copyWith(joystickX: cx, joystickY: cy, angleH: ch));
  }

  // ── Private helpers ────────────────────────────────────────

  void _updateState(RobotState next) {
    _state = next;
    if (!_robotStateController.isClosed) {
      _robotStateController.add(_state);
    }
  }

  /// Appends an XOR checksum byte to [payload] and writes the
  /// resulting frame to [characteristicUuid].
  Future<void> _writeFrame(String characteristicUuid, List<int> payload) async {
    final frame = [...payload, _xorChecksum(payload)];
    await _ble.writeCharacteristic(characteristicUuid, frame);
  }

  static int _xorChecksum(List<int> bytes) =>
      bytes.fold(0, (acc, b) => acc ^ b) & 0xFF;

  /// Encodes [value] as 4 big-endian bytes (IEEE-754 float32).
  static List<int> _floatToBytes(double value) {
    final bytes = ByteData(4)..setFloat32(0, value, Endian.little);
    return bytes.buffer.asUint8List();
  }

  static List<int> _intToBytes(int value) {
    final bytes = ByteData(2);
    bytes.setUint16(0, value, Endian.little);
    return bytes.buffer.asUint8List();
  }

  /// Frees stream resources.
  void dispose() {
    _robotStateController.close();
  }
}
