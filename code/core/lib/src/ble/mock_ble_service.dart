// ============================================================
// FILE: lib/src/ble/mock_ble_service.dart
// A fake BleService implementation backed by timers instead of
// real hardware. Lets BleRepository (and anything built on top
// of it) be exercised end-to-end — scan, connect, write — with
// no Bluetooth radio, robot, or platform channel required.
// ============================================================

import 'dart:async';

import 'ble_device.dart';
import 'ble_service.dart';

/// A small set of deterministic fake devices returned by [scanForDevices].
const _fakeDevices = [
  BleDevice(id: '00:11:22:33:44:55', name: 'Tennis Robot', rssi: -42),
  BleDevice(id: 'AA:BB:CC:DD:EE:FF', name: 'Some Other BLE Gadget', rssi: -70),
];

/// In-memory [BleService] used for local development, examples,
/// and CLI harnesses — no real Bluetooth hardware involved.
class MockBleService implements BleService {
  MockBleService({this.verbose = false});

  /// When `true`, prints every scan/connect/write call to stdout.
  final bool verbose;

  final _connectionController = StreamController<bool>.broadcast();
  bool _connected = false;

  StreamController<BleDevice>? _scanController;
  Timer? _scanTimer;

  void _log(String message) {
    if (verbose) {
      // ignore: avoid_print
      print('[MockBleService] $message');
    }
  }

  // ── Scanning ───────────────────────────────────────────────

  @override
  Stream<BleDevice> scanForDevices({Duration? timeout}) {
    _scanTimer?.cancel();
    unawaited(_scanController?.close());

    final controller = StreamController<BleDevice>();
    _scanController = controller;

    _log('scan started (timeout: ${timeout ?? 'none'})');

    var index = 0;
    final emitTimer = Timer.periodic(const Duration(milliseconds: 200), (t) {
      if (index >= _fakeDevices.length) {
        t.cancel();
        return;
      }
      final device = _fakeDevices[index++];
      _log('discovered $device');
      controller.add(device);
    });

    _scanTimer = Timer(timeout ?? const Duration(seconds: 3), () {
      emitTimer.cancel();
      _log('scan finished');
      controller.close();
    });

    controller.onCancel = () {
      emitTimer.cancel();
      _scanTimer?.cancel();
    };

    return controller.stream;
  }

  @override
  Future<void> stopScan() async {
    _log('scan stopped');
    _scanTimer?.cancel();
    await _scanController?.close();
    _scanController = null;
  }

  // ── Connection ─────────────────────────────────────────────

  @override
  Future<void> connect(BleDevice device) async {
    _log('connecting to $device...');
    await Future.delayed(const Duration(milliseconds: 300));
    _connected = true;
    _connectionController.add(true);
    _log('connected to $device');
  }

  @override
  Future<void> disconnect() async {
    _log('disconnecting');
    await Future.delayed(const Duration(milliseconds: 100));
    _connected = false;
    _connectionController.add(false);
  }

  @override
  Stream<bool> get connectionState => _connectionController.stream;

  // ── Communication ──────────────────────────────────────────

  @override
  Future<void> writeCharacteristic(
    String characteristicUuid,
    List<int> data,
  ) async {
    if (!_connected) {
      throw StateError(
        'writeCharacteristic($characteristicUuid) called while disconnected.',
      );
    }
    _log('write -> $characteristicUuid: $data');
  }

  /// Frees stream resources.
  void dispose() {
    _scanTimer?.cancel();
    _scanController?.close();
    _connectionController.close();
  }
}
