import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Drives the "connect to robot" flow shown in [DevicePickerSheet]
/// and reflected in [AppBarShell].
///
/// Unlike a simple "scan for the first robot and connect" flow,
/// this collects every nearby [BleDevice] the scan turns up so the
/// user can pick which one to connect to — mirroring
/// [BleRepository.scanForRobots], which now streams devices as
/// they're discovered instead of resolving a single one.
class AppShellViewModel extends ChangeNotifier {
  AppShellViewModel(BleRepository repo) : _repo = repo;

  final BleRepository _repo;

  StreamSubscription<BleDevice>? _scanSubscription;
  StreamSubscription<bool>? _connectionSubscription;

  final List<BleDevice> _devices = [];

  /// Devices discovered by the most recent scan, in discovery order.
  List<BleDevice> get devices => List.unmodifiable(_devices);

  bool isScanning = false;
  bool isConnecting = false;
  bool isConnected = false;

  /// Human-readable description of the last failure, if any.
  String? errorMessage;

  /// Starts (or restarts) a scan for nearby robots, clearing any
  /// previously discovered devices first.
  Future<void> startScan() async {
    await _scanSubscription?.cancel();
    _devices.clear();
    errorMessage = null;
    isScanning = true;
    notifyListeners();

    final ready = await _repo.ensurePermissionsAndBluetooth();
    if (!ready) {
      isScanning = false;
      errorMessage =
          'Bluetooth is off or permissions were denied. Enable Bluetooth '
          'and grant the requested permissions, then try again.';
      notifyListeners();
      return;
    }

    _scanSubscription = _repo.scanForRobots().listen(
      (device) {
        final index = _devices.indexWhere((d) => d.id == device.id);
        if (index >= 0) {
          _devices[index] = device;
        } else {
          _devices.add(device);
        }
        notifyListeners();
      },
      onError: (Object error) {
        isScanning = false;
        errorMessage = 'Scan failed: $error';
        notifyListeners();
      },
      onDone: () {
        isScanning = false;
        notifyListeners();
      },
    );
  }

  /// Cancels an in-progress scan, if any.
  Future<void> stopScan() async {
    final wasScanning = isScanning;
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    await _repo.stopScan();
    if (wasScanning) {
      isScanning = false;
      notifyListeners();
    }
  }

  /// Connects to a specific device the user picked from the list.
  Future<void> connectToDevice(BleDevice device) async {
    await stopScan();

    isConnecting = true;
    errorMessage = null;
    notifyListeners();

    await _connectionSubscription?.cancel();
    _connectionSubscription = _repo.connectionStream.listen((connected) {
      isConnected = connected;
      isConnecting = false;
      notifyListeners();
    });

    try {
      await _repo.connectToRobot(device);
    } catch (error) {
      isConnecting = false;
      isConnected = false;
      errorMessage = 'Could not connect to ${device.name}: $error';
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    if (!isConnected) return;
    await _repo.disconnectFromRobot();
    isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }
}
