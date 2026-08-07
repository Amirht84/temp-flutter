import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

/// UUIDs — replace these with the actual ones from the robot firmware.
/// These are standard Nordic UART Service (NUS) UUIDs as a sensible default.
const _serviceUuid = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';
const _txCharUuid =
    '6E400002-B5A3-F393-E0A9-E50E24DCCA9E'; // write (phone → robot)
// ignore: unused_element — reserved for future robot→phone notifications
const _rxCharUuid =
    '6E400003-B5A3-F393-E0A9-E50E24DCCA9E'; // notify (robot → phone)

enum BleConnectionState { disconnected, connecting, connected }

class BleService {
  final _ble = FlutterReactiveBle();

  StreamSubscription<DiscoveredDevice>? _scanSub;
  StreamSubscription<ConnectionStateUpdate>? _connSub;

  String? _connectedDeviceId;
  bool get isConnected => _connectedDeviceId != null;

  final _devicesController =
      StreamController<List<DiscoveredDevice>>.broadcast();
  Stream<List<DiscoveredDevice>> get devicesStream => _devicesController.stream;

  final _connectionController =
      StreamController<BleConnectionState>.broadcast();
  Stream<BleConnectionState> get connectionStream =>
      _connectionController.stream;

  final List<DiscoveredDevice> _discovered = [];

  /// Start scanning for BLE devices.
  void startScan() {
    _discovered.clear();
    _scanSub?.cancel();
    _scanSub = _ble
        .scanForDevices(
          withServices:
              [], // scan all; filter in UI by name or allow user to pick
          scanMode: ScanMode.lowLatency,
        )
        .listen((device) {
          final idx = _discovered.indexWhere((d) => d.id == device.id);
          if (idx >= 0) {
            _discovered[idx] = device;
          } else {
            _discovered.add(device);
          }
          _devicesController.add(List.unmodifiable(_discovered));
        });
  }

  void stopScan() {
    _scanSub?.cancel();
    _scanSub = null;
  }

  Future<void> connect(String deviceId) async {
    stopScan();
    _connSub?.cancel();
    _connectedDeviceId = null;
    _connectionController.add(BleConnectionState.connecting);

    final completer = Completer<void>();
    _connSub = _ble
        .connectToDevice(
          id: deviceId,
          connectionTimeout: const Duration(seconds: 10),
        )
        .listen(
          (update) {
            switch (update.connectionState) {
              case DeviceConnectionState.connected:
                _connectedDeviceId = deviceId;
                _connectionController.add(BleConnectionState.connected);
                if (!completer.isCompleted) completer.complete();
              case DeviceConnectionState.disconnected:
                _connectedDeviceId = null;
                _connectionController.add(BleConnectionState.disconnected);
              default:
                break;
            }
          },
          onError: (Object e) {
            _connectionController.add(BleConnectionState.disconnected);
            if (!completer.isCompleted) completer.completeError(e);
          },
        );

    return completer.future;
  }

  Future<void> disconnect() async {
    await _connSub?.cancel();
    _connSub = null;
    _connectedDeviceId = null;
    _connectionController.add(BleConnectionState.disconnected);
  }

  /// Write [bytes] to the TX characteristic (phone → robot).
  Future<void> writeCommand(List<int> bytes) async {
    final deviceId = _connectedDeviceId;
    if (deviceId == null) throw StateError('Not connected');

    final characteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: Uuid.parse(_serviceUuid),
      characteristicId: Uuid.parse(_txCharUuid),
    );
    await _ble.writeCharacteristicWithResponse(characteristic, value: bytes);
  }

  void dispose() {
    _scanSub?.cancel();
    _connSub?.cancel();
    _devicesController.close();
    _connectionController.close();
  }
}
