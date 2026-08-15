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

  /// Discovered characteristics, keyed by their (lower-cased) UUID
  /// string — one entry per constant in `BleConstants`
  /// (RPM, Hangle, Vangle, Shoot, Stop, Movement).
  final Map<String, fbp.BluetoothCharacteristic> _characteristics = {};

  StreamSubscription<List<fbp.ScanResult>>? _scanSub;
  StreamSubscription<fbp.BluetoothConnectionState>? _connStateSub;

  final _connectionController = StreamController<bool>.broadcast();

  final _serviceUuid = fbp.Guid(BleConstants.robotServiceUuid);

  /// Characteristics that get an acknowledged write since they're
  /// safety-critical. Everything else (RPM, angles, joystick) is
  /// written unacknowledged for lower latency.
  static const _criticalCharacteristics = {
    BleConstants.Shoot,
    BleConstants.UNUSED,
  };

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
        // DEBUG: print every device we see and exactly what service UUIDs
        // (if any) came through in its advertisement packet. This tells us
        // whether the Pi's adv data actually contains the service UUID,
        // independent of the withServices scan filter below.
        // ignore: avoid_print
        print(
          'SCAN SEEN: id=$id name="${r.advertisementData.advName}" '
          'rssi=${r.rssi} advServiceUuids=${r.advertisementData.serviceUuids}',
        );
        if (seenIds.add(id)) {
          final name = r.device.platformName.isNotEmpty
              ? r.device.platformName
              : r.advertisementData.advName;
          controller.add(BleDevice(id: id, name: name, rssi: r.rssi));
        }
      }
    }, onError: controller.addError);
    fbp.FlutterBluePlus.cancelWhenScanComplete(_scanSub!);

    // NOTE: `isScanning` is a broadcast stream that replays its *current*
    // value to a new listener. If we listen right after firing (not
    // awaiting) startScan(), the adapter may not have flipped to "scanning"
    // yet, so the very first value we see can still be `false` — closing
    // the stream instantly, before any results arrive. Guard against that
    // by only closing once we've actually observed `true` first.
    bool scanStarted = false;
    StreamSubscription<bool>? isScanningSub;
    isScanningSub = fbp.FlutterBluePlus.isScanning.listen((scanning) {
      if (scanning) {
        scanStarted = true;
      } else if (scanStarted) {
        isScanningSub?.cancel();
        controller.close();
      }
    });

    // DEBUG: withServices filter temporarily disabled to confirm whether
    // the Pi's advertisement actually carries the service UUID. Once
    // confirmed, either restore the filter (if the UUID shows up in the
    // logged advServiceUuids above) or switch to filtering by name/id
    // client-side instead (if it doesn't).
    fbp.FlutterBluePlus.startScan(
      // withServices: [_serviceUuid],
      timeout: timeout,
    ).catchError((Object e) => controller.addError(e));

    controller.onCancel = () async {
      await _scanSub?.cancel();
      await isScanningSub?.cancel();
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

    await target.connect(
      timeout: const Duration(seconds: 15),
      license: fbp.License.nonprofit,
    );

    final services = await target.discoverServices();
    final robotService = services.firstWhere(
      (s) => s.uuid == _serviceUuid,
      orElse: () => throw StateError(
        'Robot service ${BleConstants.robotServiceUuid} not found — '
        'is this really the robot, and is firmware advertising the '
        'right UUIDs?',
      ),
    );

    _characteristics.clear();
    for (final c in robotService.characteristics) {
      _characteristics[c.uuid.str.toLowerCase()] = c;
    }

    // Fail fast with a clear message naming exactly which
    // characteristic is missing, instead of a null-check crash
    // later on the first write.
    const expected = {
      'RPM': BleConstants.RPM,
      'Hangle': BleConstants.Movement,
      'Vangle': BleConstants.Vangle,
      'Shoot': BleConstants.Shoot,
      'Stop': BleConstants.UNUSED,
      'Movement': BleConstants.Movement,
    };
    for (final entry in expected.entries) {
      if (!_characteristics.containsKey(entry.value.toLowerCase())) {
        throw StateError(
          '${entry.key} characteristic (${entry.value}) not found on robot',
        );
      }
    }
  }

  @override
  Future<void> disconnect() async {
    await _connStateSub?.cancel();
    _connStateSub = null;
    await _device?.disconnect();
    _characteristics.clear();
    _device = null;
  }

  @override
  Stream<bool> get connectionState => _connectionController.stream;

  // ── Communication ──────────────────────────────────────────

  @override
  Future<void> writeCharacteristic(
    String characteristicUuid,
    List<int> data,
  ) async {
    final char = _characteristics[characteristicUuid.toLowerCase()];
    if (char == null) {
      throw StateError(
        'writeCharacteristic($characteristicUuid) called before a '
        'successful connect(), or the characteristic was not found.',
      );
    }
    final isCritical = _criticalCharacteristics.contains(characteristicUuid);
    await char.write(data, withoutResponse: !isCritical);
  }

  // ── Cleanup ────────────────────────────────────────────────

  void dispose() {
    _scanSub?.cancel();
    _connStateSub?.cancel();
    _connectionController.close();
  }
}
