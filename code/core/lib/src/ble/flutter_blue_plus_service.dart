// ============================================================
// FILE: lib/src/ble/flutter_blue_plus_service.dart
// The REAL BleService implementation — talks to an actual
// robot over Bluetooth Low Energy using flutter_blue_plus.
//
// This is a drop-in replacement for MockBleService: same
// `BleService` contract, so BleRepository, RobotViewModel, and
// the UI never need to know which one they're using.
//
// Requires:
//   flutter pub add flutter_blue_plus
// and the Android/iOS permission setup described in
// README_REAL_TEST.md.
// ============================================================

import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

import 'ble_constants.dart';
import 'ble_device.dart';
import 'ble_service.dart';

class FlutterBluePlusService implements BleService {
  fbp.BluetoothDevice? _device;
  fbp.BluetoothCharacteristic? _commandChar;
  fbp.BluetoothCharacteristic? _statusChar;

  StreamSubscription<List<fbp.ScanResult>>? _scanSub;
  StreamSubscription<fbp.BluetoothConnectionState>? _connStateSub;
  StreamSubscription<List<int>>? _notifySub;

  final _connectionController = StreamController<bool>.broadcast();
  final _statusController = StreamController<List<int>>.broadcast();

  final _serviceUuid = fbp.Guid(BleConstants.robotServiceUuid);
  final _commandCharUuid = fbp.Guid(BleConstants.commandCharUuid);
  final _statusCharUuid = fbp.Guid(BleConstants.statusCharUuid);

  /// Call once (e.g. on app start) and await before scanning, so you get
  /// a clear error instead of a scan that silently finds nothing.
  Future<void> ensureBluetoothOn({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (await fbp.FlutterBluePlus.isSupported == false) {
      throw StateError('This device has no Bluetooth radio.');
    }
    final state = await fbp.FlutterBluePlus.adapterState
        .firstWhere((s) => s != fbp.BluetoothAdapterState.unknown)
        .timeout(timeout);
    if (state != fbp.BluetoothAdapterState.on) {
      throw StateError('Bluetooth is off — please enable it (state: $state).');
    }
  }

  // ── Scanning ───────────────────────────────────────────────

  @override
  Stream<BleDevice> scanForDevices({Duration? timeout}) {
    final controller = StreamController<BleDevice>();
    final seenIds = <String>{};

    _scanSub?.cancel();
    _scanSub = fbp.FlutterBluePlus.onScanResults.listen((results) {
      for (final r in results) {
        final id = r.device.remoteId.str;
        if (seenIds.add(id)) {
          final name = r.device.platformName.isNotEmpty
              ? r.device.platformName
              : r.advertisementData.advName;
          controller.add(BleDevice(id: id, name: name, rssi: r.rssi));
        }
      }
    }, onError: controller.addError);
    fbp.FlutterBluePlus.cancelWhenScanComplete(_scanSub!);

    // Filter by our robot's service UUID so we don't see every random BLE
    // device (fridges, headphones, etc.) — same UUID used in ble_constants.
    fbp.FlutterBluePlus
        .startScan(withServices: [_serviceUuid], timeout: timeout)
        .catchError((Object e) => controller.addError(e));

    fbp.FlutterBluePlus.isScanning
        .where((scanning) => !scanning)
        .first
        .then((_) => controller.close());

    controller.onCancel = () async {
      await _scanSub?.cancel();
      await fbp.FlutterBluePlus.stopScan();
    };

    return controller.stream;
  }

  @override
  Future<void> stopScan() => fbp.FlutterBluePlus.stopScan();

  // ── Connection ─────────────────────────────────────────────

  @override
  Future<void> connect(BleDevice device) async {
    final target = fbp.BluetoothDevice.fromId(device.id);
    _device = target;

    await _connStateSub?.cancel();
    _connStateSub = target.connectionState.listen((state) {
      _connectionController.add(
        state == fbp.BluetoothConnectionState.connected,
      );
    });

    await target.connect(timeout: const Duration(seconds: 15));

    final services = await target.discoverServices();
    final robotService = services.firstWhere(
      (s) => s.uuid == _serviceUuid,
      orElse: () => throw StateError(
        'Robot service ${BleConstants.robotServiceUuid} not found — '
        'is this really the robot, and is firmware advertising the '
        'right UUIDs?',
      ),
    );

    _commandChar = robotService.characteristics.firstWhere(
      (c) => c.uuid == _commandCharUuid,
      orElse: () => throw StateError('Command characteristic not found'),
    );
    _statusChar = robotService.characteristics.firstWhere(
      (c) => c.uuid == _statusCharUuid,
      orElse: () => throw StateError('Status characteristic not found'),
    );

    await _notifySub?.cancel();
    await _statusChar!.setNotifyValue(true);
    _notifySub = _statusChar!.lastValueStream.listen(
      _statusController.add,
      onError: _statusController.addError,
    );
  }

  @override
  Future<void> disconnect() async {
    await _notifySub?.cancel();
    _notifySub = null;
    await _connStateSub?.cancel();
    _connStateSub = null;
    await _device?.disconnect();
    _commandChar = null;
    _statusChar = null;
    _device = null;
  }

  @override
  Stream<bool> get connectionState => _connectionController.stream;

  // ── Communication ──────────────────────────────────────────

  @override
  Future<void> writeCommand(List<int> data) async {
    final char = _commandChar;
    if (char == null) {
      throw StateError('writeCommand() called before a successful connect()');
    }

    // Launch/stop (0x05 / 0x06 — see BleRepository._encodeCommand) get an
    // acknowledged write since they're safety-critical. Continuous slider
    // updates (motor speed, angles) go unacknowledged for lower latency —
    // losing one of many rapid updates doesn't matter.
    final isCritical = data.isNotEmpty && (data[0] == 0x05 || data[0] == 0x06);
    await char.write(data, withoutResponse: !isCritical);
  }

  @override
  Stream<List<int>> get statusNotifications => _statusController.stream;

  // ── Cleanup ────────────────────────────────────────────────

  void dispose() {
    _scanSub?.cancel();
    _connStateSub?.cancel();
    _notifySub?.cancel();
    _connectionController.close();
    _statusController.close();
  }
}
