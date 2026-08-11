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
//  • parses incoming frames on each characteristic the same way
//    real firmware would (validates length + XOR checksum)
//  • logs the decoded value so you can sanity-check the encoding
//    coming out of BleRepository before touching real hardware
// ============================================================

import 'dart:async';
import 'dart:typed_data';

import 'ble_constants.dart';
import 'ble_device.dart';
import 'ble_service.dart';

class MockBleService implements BleService {
  MockBleService({this.verbose = true});

  /// Prints what the fake robot receives — handy for a CLI.
  final bool verbose;

  final _connectionController = StreamController<bool>.broadcast();

  bool _connected = false;
  StreamController<BleDevice>? _scanController;
  Timer? _scanTicker;

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
    await Future.delayed(
      const Duration(milliseconds: 250),
    ); // simulate radio latency
    _connected = true;
    _log('connected to ${device.name}');
    _connectionController.add(true);
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
    _log('disconnected');
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
      throw StateError('writeCharacteristic() called while not connected');
    }

    switch (characteristicUuid) {
      case BleConstants.RPM:
        _handleRpm(data);
      case BleConstants.Hangle:
        _handleAngle('horizontal', data);
      case BleConstants.Vangle:
        _handleAngle('vertical', data);
      case BleConstants.Movement:
        _handleJoystick(data);
      case BleConstants.Shoot:
        _log('SHOOT (raw: $data)');
      case BleConstants.Stop:
        _log('STOP (raw: $data)');
      default:
        throw ArgumentError('Unknown characteristic UUID: $characteristicUuid');
    }
  }

  void _handleRpm(List<int> data) {
    if (!_checksumOk(data, 4)) return;
    final top = (data[0] << 8) | data[1];
    final bottom = (data[2] << 8) | data[3];
    _log('RPM -> top: $top, bottom: $bottom');
  }

  void _handleAngle(String label, List<int> data) {
    if (!_checksumOk(data, 4)) return;
    final value = ByteData.sublistView(
      Uint8List.fromList(data.sublist(0, 4)),
    ).getFloat32(0, Endian.big);
    _log('$label angle -> $value°');
  }

  void _handleJoystick(List<int> data) {
    if (!_checksumOk(data, 8)) return;
    final bytes = Uint8List.fromList(data.sublist(0, 8));
    final x = ByteData.sublistView(bytes).getFloat32(0, Endian.big);
    final y = ByteData.sublistView(bytes).getFloat32(4, Endian.big);
    _log('joystick -> x: $x, y: $y');
  }

  /// Validates the trailing XOR checksum byte after [payloadLength]
  /// payload bytes. Mirrors how real firmware would silently drop a
  /// corrupt frame.
  bool _checksumOk(List<int> data, int payloadLength) {
    if (data.length != payloadLength + 1) {
      _log(
        'DROPPED malformed frame (expected ${payloadLength + 1} bytes): $data',
      );
      return false;
    }
    final payload = data.sublist(0, payloadLength);
    final expected = payload.fold(0, (acc, b) => acc ^ b) & 0xFF;
    if (data[payloadLength] != expected) {
      _log('DROPPED corrupt frame $data (checksum mismatch)');
      return false;
    }
    return true;
  }

  /// Frees resources — call when the CLI session ends.
  void dispose() {
    _scanTicker?.cancel();
    _scanController?.close();
    _connectionController.close();
  }
}
