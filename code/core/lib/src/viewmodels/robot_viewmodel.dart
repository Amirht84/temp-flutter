/*// ============================================================
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

  // ── Initialisation ─────────────────────────────────────────

  void _init() {
    // Mirror BLE connection state into our enum.
    _connSub = _repo.connectionStream.listen((connected) {
      _setStatus(
        connected ? ConnectionStatus.connected : ConnectionStatus.disconnected,
      );
    }, onError: (e) => _setError(e.toString()));

    // Mirror last-commanded state (see RobotState docs — this
    // protocol has no telemetry notify, so this simply echoes
    // what we last told the robot to do).
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

  /// Sets the top & bottom flywheel motor RPM.
  Future<void> setRpm(int topRpm, int bottomRpm) =>
      _sendSafely(() => _repo.setRpm(topRpm, bottomRpm));

  /// Sets the horizontal (pan) angle, in degrees.
  Future<void> setAngleH(double degrees) =>
      _sendSafely(() => _repo.setAngleH(degrees));

  /// Sets the vertical (tilt) angle, in degrees.
  Future<void> setAngleV(double degrees) =>
      _sendSafely(() => _repo.setAngleV(degrees));

  /// Fires the launcher.
  Future<void> shoot() => _sendSafely(_repo.shoot);

  /// Stops the launcher / motors.
  Future<void> stop() => _sendSafely(_repo.stop);

  /// Drives the robot via a normalised 2-axis joystick (-1.0..1.0).
  Future<void> joystick(double x, double y) =>
      _sendSafely(() => _repo.joystick(x, y));

  // ── Private helpers ────────────────────────────────────────

  Future<void> _sendSafely(Future<void> Function() action) async {
    if (!isConnected) return;
    try {
      await action();
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
*/