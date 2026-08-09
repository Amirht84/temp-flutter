// ============================================================
// FILE: lib/src/viewmodels/robot_viewmodel.dart
// The single ViewModel consumed by the UI layer.
// It holds all mutable UI state and exposes command methods.
// Uses ChangeNotifier so it works with Flutter's
// ListenableBuilder / Consumer out of the box, but the
// BLE / model layers have NO Flutter dependency at all.
// ============================================================

import 'dart:async';

import 'package:flutter/foundation.dart'; // ChangeNotifier

import '../ble/ble_device.dart';
import '../ble/ble_repository.dart';
import '../models/robot_command.dart';
import '../models/robot_state.dart';

/// Connection life-cycle states.
enum ConnectionStatus { disconnected, scanning, connecting, connected, error }

/// All UI state + command handlers in one place.
///
/// The View binds to the public getters and calls the public
/// methods — it never touches [BleRepository] directly.
class RobotViewModel extends ChangeNotifier {
  RobotViewModel({required BleRepository repository}) : _repo = repository {
    _init();
  }

  final BleRepository _repo;

  // ── Subscriptions ──────────────────────────────────────────
  StreamSubscription<bool>? _connSub;
  StreamSubscription<RobotState>? _stateSub;
  StreamSubscription<BleDevice>? _scanSub;

  // ── Observed state ─────────────────────────────────────────

  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  ConnectionStatus get connectionStatus => _connectionStatus;

  RobotState _robotState = RobotState.initial;
  RobotState get robotState => _robotState;

  /// Devices discovered during the current scan.
  final List<BleDevice> scannedDevices = [];

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isConnected => _connectionStatus == ConnectionStatus.connected;

  // ── Slider / picker backing values ─────────────────────────

  int _topMotorSpeed = 0;
  int get topMotorSpeed => _topMotorSpeed;

  int _bottomMotorSpeed = 0;
  int get bottomMotorSpeed => _bottomMotorSpeed;

  int _verticalAngle = 0;
  int get verticalAngle => _verticalAngle;

  int _horizontalAngle = 0;
  int get horizontalAngle => _horizontalAngle;

  // ── Initialisation ─────────────────────────────────────────

  void _init() {
    // Mirror BLE connection state into our enum.
    _connSub = _repo.connectionStream.listen((connected) {
      _setStatus(
        connected ? ConnectionStatus.connected : ConnectionStatus.disconnected,
      );
    }, onError: (e) => _setError(e.toString()));

    // Mirror robot telemetry into _robotState.
    _stateSub = _repo.robotStateStream.listen((state) {
      _robotState = state;
      notifyListeners();
    }, onError: (e) => _setError(e.toString()));
  }

  // ── Scanning ───────────────────────────────────────────────

  /// Starts a BLE scan and populates [scannedDevices].
  void startScan() {
    scannedDevices.clear();
    _setStatus(ConnectionStatus.scanning);

    _scanSub?.cancel();
    _scanSub = _repo.scanForRobots().listen(
      (device) {
        if (!scannedDevices.contains(device)) {
          scannedDevices.add(device);
          notifyListeners();
        }
      },
      onDone: () {
        // Scan window closed without an explicit connect.
        if (_connectionStatus == ConnectionStatus.scanning) {
          _setStatus(ConnectionStatus.disconnected);
        }
      },
      onError: (e) => _setError(e.toString()),
    );
  }

  Future<void> stopScan() async {
    await _scanSub?.cancel();
    await _repo.stopScan();
    if (_connectionStatus == ConnectionStatus.scanning) {
      _setStatus(ConnectionStatus.disconnected);
    }
  }

  // ── Connection ─────────────────────────────────────────────

  Future<void> connectTo(BleDevice device) async {
    try {
      _setStatus(ConnectionStatus.connecting);
      await _repo.connectToRobot(device);
      // _connSub will flip status to connected on success.
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> disconnect() async {
    try {
      await _repo.disconnectFromRobot();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── 6 UI control methods ───────────────────────────────────

  /// Called when the user changes the top motor speed slider.
  Future<void> setTopMotorSpeed(int speed) async {
    _topMotorSpeed = speed;
    notifyListeners();
    await _sendSafely(RobotCommand.topMotorSpeed(speed));
  }

  /// Called when the user changes the bottom motor speed slider.
  Future<void> setBottomMotorSpeed(int speed) async {
    _bottomMotorSpeed = speed;
    notifyListeners();
    await _sendSafely(RobotCommand.bottomMotorSpeed(speed));
  }

  /// Called when the user changes the vertical angle slider.
  Future<void> setVerticalAngle(int degrees) async {
    _verticalAngle = degrees;
    notifyListeners();
    await _sendSafely(RobotCommand.verticalAngle(degrees));
  }

  /// Called when the user changes the horizontal angle slider.
  Future<void> setHorizontalAngle(int degrees) async {
    _horizontalAngle = degrees;
    notifyListeners();
    await _sendSafely(RobotCommand.horizontalAngle(degrees));
  }

  /// Called when the user taps the **Launch** button.
  Future<void> launch() async => _sendSafely(const RobotCommand.launch());

  /// Called when the user taps the **Stop** button.
  Future<void> stop() async => _sendSafely(const RobotCommand.stop());

  // ── Private helpers ────────────────────────────────────────

  Future<void> _sendSafely(RobotCommand command) async {
    if (!isConnected) return;
    try {
      await _repo.sendCommand(command);
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setStatus(ConnectionStatus status) {
    _connectionStatus = status;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _connectionStatus = ConnectionStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  // ── Cleanup ────────────────────────────────────────────────

  @override
  void dispose() {
    _connSub?.cancel();
    _stateSub?.cancel();
    _scanSub?.cancel();
    _repo.dispose();
    super.dispose();
  }
}
