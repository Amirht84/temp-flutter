// ============================================================
// FILE: lib/src/ble/mock_ble_service.dart
// A fake BLE hardware implementation used ONLY for development
// / CLI testing. It implements the same `BleService` contract
// a real flutter_blue_plus adapter would, so `BleRepository`
// (and later the ViewModel) can be exercised end-to-end without
// any real Bluetooth hardware or Flutter runtime.
//
// It simulates a robot that:
//  • is "discoverable" during scanForDevices()
//  • parses incoming command frames the same way real firmware
//    would (validates length + checksum)
//  • updates an internal fake robot state accordingly
//  • periodically pushes status notifications back, encoded
//    exactly the way BleRepository._decodeState() expects them
// ============================================================

import 'dart:async';

import 'ble_device.dart';
import 'ble_service.dart';

class MockBleService implements BleService {
  MockBleService({this.verbose = true, this.simulateNotifications = true});

  /// Prints what the fake robot receives/sends — handy for a CLI.
  final bool verbose;

  /// Whether to periodically push status frames while connected.
  final bool simulateNotifications;

  final _connectionController = StreamController<bool>.broadcast();
  final _statusController = StreamController<List<int>>.broadcast();

  bool _connected = false;
  Timer? _notifyTimer;
  StreamController<BleDevice>? _scanController;
  Timer? _scanTicker;

  // ── Fake internal robot state, mutated by writeCommand() ────
  int _topSpeed = 0;
  int _bottomSpeed = 0;
  bool _isRunning = false;

  static final _fakeDevices = <BleDevice>[
    const BleDevice(id: 'AA:BB:CC:DD:EE:01', name: 'TennisBot-01', rssi: -42),
    const BleDevice(id: 'AA:BB:CC:DD:EE:02', name: 'TennisBot-02', rssi: -61),
    const BleDevice(id: 'AA:BB:CC:DD:EE:03', name: 'RandomFridge', rssi: -78),
  ];

  void _log(String msg) {
    if (verbose) print('  [mock-ble] $msg');
  }

  // ── Scanning ───────────────────────────────────────────────

  @override
  Stream<BleDevice> scanForDevices({Duration? timeout}) {
    _scanTicker?.cancel();
    _scanController?.close();

    final controller = StreamController<BleDevice>();
    _scanController = controller;

    var i = 0;
    _scanTicker = Timer.periodic(const Duration(milliseconds: 350), (t) {
      if (i >= _fakeDevices.length) {
        t.cancel();
        if (!controller.isClosed) controller.close();
        return;
      }
      final device = _fakeDevices[i++];
      _log('advertising ${device.name} (${device.id})');
      if (!controller.isClosed) controller.add(device);
    });

    if (timeout != null) {
      Timer(timeout, () {
        _scanTicker?.cancel();
        if (!controller.isClosed) controller.close();
      });
    }

    controller.onCancel = () => _scanTicker?.cancel();
    return controller.stream;
  }

  @override
  Future<void> stopScan() async {
    _scanTicker?.cancel();
    await _scanController?.close();
  }

  // ── Connection ─────────────────────────────────────────────

  @override
  Future<void> connect(BleDevice device) async {
    await Future.delayed(const Duration(milliseconds: 250)); // simulate radio latency
    _connected = true;
    _log('connected to ${device.name}');
    _connectionController.add(true);
    if (simulateNotifications) _startNotifying();
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
    _notifyTimer?.cancel();
    _log('disconnected');
    _connectionController.add(false);
  }

  @override
  Stream<bool> get connectionState => _connectionController.stream;

  // ── Communication ──────────────────────────────────────────

  @override
  Future<void> writeCommand(List<int> data) async {
    if (!_connected) {
      throw StateError('writeCommand() called while not connected');
    }
    if (data.length != 4) {
      throw ArgumentError('Malformed frame (expected 4 bytes): $data');
    }

    final cmdType = data[0];
    final high = data[1];
    final low = data[2];
    final checksum = data[3];
    final expected = (cmdType ^ high ^ low) & 0xFF;

    if (checksum != expected) {
      // Mirrors how real firmware would silently drop a corrupt frame.
      _log('DROPPED corrupt frame $data (checksum $checksum != $expected)');
      return;
    }

    final value = (high << 8) | low;

    switch (cmdType) {
      case 0x01:
        _topSpeed = value;
        _log('top motor speed -> $_topSpeed%');
      case 0x02:
        _bottomSpeed = value;
        _log('bottom motor speed -> $_bottomSpeed%');
      case 0x03:
        _log('vertical angle raw byte -> $value (offset +45)');
      case 0x04:
        _log('horizontal angle raw byte -> $value (offset +180)');
      case 0x05:
        _isRunning = true;
        _log('LAUNCH');
      case 0x06:
        _isRunning = false;
        _topSpeed = 0;
        _bottomSpeed = 0;
        _log('STOP');
      default:
        throw ArgumentError(
          'Unknown command type: 0x${cmdType.toRadixString(16)}',
        );
    }

    _emitStatus();
  }

  @override
  Stream<List<int>> get statusNotifications => _statusController.stream;

  // ── Internal helpers ───────────────────────────────────────

  void _startNotifying() {
    _notifyTimer?.cancel();
    // Robot "heartbeats" its telemetry every couple seconds, same as
    // real BLE notify characteristics typically would.
    _notifyTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _emitStatus(),
    );
    _emitStatus(); // send one immediately on connect
  }

  void _emitStatus() {
    if (_statusController.isClosed) return;
    final isRunningByte = _isRunning ? 0x01 : 0x00;
    final checksum = (isRunningByte ^ _topSpeed ^ _bottomSpeed) & 0xFF;
    _statusController.add([isRunningByte, _topSpeed, _bottomSpeed, checksum]);
  }

  /// Frees resources — call when the CLI session ends.
  void dispose() {
    _notifyTimer?.cancel();
    _scanTicker?.cancel();
    _scanController?.close();
    _connectionController.close();
    _statusController.close();
  }
}
