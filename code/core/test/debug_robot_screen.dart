// ============================================================
// FILE: test/debug_robot_screen.dart
//
// Throwaway test harness — NOT the real UI.
// Used to test the real BLE path against physical hardware.
//
// Run:
//   flutter run -t test/main_debug.dart
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

import '../lib/src/ble/ble_device.dart';
import '../lib/src/ble/ble_repository.dart';
import '../lib/src/ble/flutter_blue_plus_service.dart';
import '../lib/src/models/robot_state.dart';

class DebugRobotScreen extends StatefulWidget {
  const DebugRobotScreen({super.key});

  @override
  State<DebugRobotScreen> createState() => _DebugRobotScreenState();
}

class _DebugRobotScreenState extends State<DebugRobotScreen> {
  late final FlutterBluePlusService _ble;
  late final BleRepository _repo;

  StreamSubscription<bool>? _connectionSubscription;
  StreamSubscription<RobotState>? _robotStateSubscription;
  StreamSubscription<BleDevice>? _scanSubscription;

  final List<BleDevice> _found = [];

  BleDevice? _connected;

  bool _isConnected = false;
  bool _isScanning = false;

  RobotState _state = RobotState.initial;

  String _log = '';

  double _topRpm = 0;
  double _bottomRpm = 0;

  double _angleH = 0;
  double _angleV = 0;

  double _joyX = 0;
  double _joyY = 0;

  @override
  void initState() {
    super.initState();

    _ble = FlutterBluePlusService();
    _repo = BleRepository(bleService: _ble);

    _requestPermissions();

    _connectionSubscription = _repo.connectionStream.listen((connected) {
      if (!mounted) return;

      setState(() {
        _isConnected = connected;
      });

      _appendLog(connected ? 'connected' : 'disconnected');
    });

    _robotStateSubscription = _repo.robotStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        _state = state;
      });
    });
  }

  Future<void> _requestPermissions() async {
    final status = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (!mounted) return;

    if (status[Permission.bluetoothScan]?.isDenied == true ||
        status[Permission.bluetoothConnect]?.isDenied == true) {
      _appendLog(
        '⚠️ Bluetooth permissions not fully granted.',
      );
    }
  }

  void _appendLog(String line) {
    if (!mounted) return;

    setState(() {
      _log = '$line\n$_log';
    });
  }

  Future<void> _scan() async {
    try {
      await _ble.ensureBluetoothOn();
    } catch (e) {
      _appendLog('❌ $e');
      return;
    }

    if (!mounted) return;

    setState(() {
      _found.clear();
      _isScanning = true;
    });

    await _scanSubscription?.cancel();

    _scanSubscription = _repo.scanForRobots().listen(
      (device) {
        if (!mounted) return;

        // Avoid adding the same device multiple times.
        final alreadyFound = _found.any(
          (d) => d.id == device.id,
        );

        if (!alreadyFound) {
          setState(() {
            _found.add(device);
          });
        }
      },
      onDone: () {
        if (!mounted) return;

        setState(() {
          _isScanning = false;
        });
      },
      onError: (e) {
        _appendLog('❌ scan error: $e');

        if (!mounted) return;

        setState(() {
          _isScanning = false;
        });
      },
    );
  }

  Future<void> _connect(BleDevice device) async {
    try {
      _appendLog('connecting to ${device.name}...');

      await _repo.connectToRobot(device);

      if (!mounted) return;

      setState(() {
        _connected = device;
      });
    } catch (e) {
      _appendLog('❌ connect failed: $e');
    }
  }

  Future<void> _disconnect() async {
    try {
      await _repo.disconnectFromRobot();

      if (!mounted) return;

      setState(() {
        _connected = null;
        _isConnected = false;
        _joyX = 0;
        _joyY = 0;
      });
    } catch (e) {
      _appendLog('❌ disconnect failed: $e');
    }
  }

  Future<void> _run(
    String label,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (e) {
      _appendLog('❌ $label failed: $e');
    }
  }

  // ============================================================
  // JOYSTICK
  // ============================================================

  void _onJoystickMove(double x, double y) {
    if (!mounted) return;

    setState(() {
      _joyX = x;
      _joyY = y;
    });

    if (!_isConnected) return;

    _run(
      'joystick',
      () => _repo.joystick(
        x,
        y,
        _angleH,
      ),
    );
  }

  void _onJoystickRelease() {
    if (!mounted) return;

    setState(() {
      _joyX = 0;
      _joyY = 0;
    });

    if (!_isConnected) return;

    // Return joystick command to neutral position.
    _run(
      'joystick stop',
      () => _repo.joystick(
        0,
        0,
        _angleH,
      ),
    );
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    _robotStateSubscription?.cancel();
    _scanSubscription?.cancel();

    _repo.dispose();
    _ble.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Robot BLE — Real Hardware Test',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ==================================================
            // CONNECTION
            // ==================================================

            Row(
              children: [
                Icon(
                  _isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'Connected' : 'Not connected',
                ),
                const Spacer(),
                if (_connected == null)
                  ElevatedButton(
                    onPressed: _isScanning ? null : _scan,
                    child: Text(
                      _isScanning ? 'Scanning...' : 'Scan',
                    ),
                  )
                else
                  OutlinedButton(
                    onPressed: _disconnect,
                    child: const Text('Disconnect'),
                  ),
              ],
            ),

            // ==================================================
            // DEVICE LIST
            // ==================================================

            if (_connected == null && _found.isNotEmpty)
              SizedBox(
                height: 140,
                child: ListView.builder(
                  itemCount: _found.length,
                  itemBuilder: (context, i) {
                    final d = _found[i];

                    return ListTile(
                      dense: true,
                      title: Text(
                        d.name.isEmpty ? '(unnamed)' : d.name,
                      ),
                      subtitle: Text(
                        '${d.id}  rssi: ${d.rssi}',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _connect(d),
                        child: const Text('Connect'),
                      ),
                    );
                  },
                ),
              ),

            const Divider(),

            // ==================================================
            // ROBOT STATE
            // ==================================================

            Text(
              'Last commanded: $_state',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // RPM
            // ==================================================

            _slider(
              'Top RPM',
              _topRpm,
              0,
              100,
              (v) {
                setState(() {
                  _topRpm = v;
                });

                _run(
                  'setRpm',
                  () => _repo.setRpm(
                    v.round(),
                    _bottomRpm.round(),
                  ),
                );
              },
            ),

            _slider(
              'Bottom RPM',
              _bottomRpm,
              0,
              100,
              (v) {
                setState(() {
                  _bottomRpm = v;
                });

                _run(
                  'setRpm',
                  () => _repo.setRpm(
                    _topRpm.round(),
                    v.round(),
                  ),
                );
              },
            ),

            // ==================================================
            // ANGLES
            // ==================================================

            _slider(
              'Angle H',
              _angleH,
              -180,
              180,
              (v) {
                setState(() {
                  _angleH = v;
                });

                _run(
                  'setAngleH',
                  () => _repo.joystick(
                    _joyX,
                    _joyY,
                    v,
                  ),
                );
              },
            ),

            _slider(
              'Angle V',
              _angleV,
              -45,
              45,
              (v) {
                setState(() {
                  _angleV = v;
                });

                _run(
                  'setAngleV',
                  () => _repo.setAngleV(v),
                );
              },
            ),

            const SizedBox(height: 10),

            // ==================================================
            // JOYSTICK
            // ==================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Joystick',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'X: ${_joyX.toStringAsFixed(2)}',
                ),
                const SizedBox(width: 12),
                Text(
                  'Y: ${_joyY.toStringAsFixed(2)}',
                ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Center(
                child: Opacity(
                  opacity: _isConnected ? 1.0 : 0.4,
                  child: IgnorePointer(
                    ignoring: !_isConnected,
                    child: Joystick(
                      mode: JoystickMode.all,
                      listener: (details) {
                        _onJoystickMove(
                          details.x,
                          details.y,
                        );
                      },
                      onStickDragEnd: _onJoystickRelease,
                    ),
                  ),
                ),
              ),
            ),

            // ==================================================
            // SHOOT / STOP
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isConnected
                        ? () => _run(
                              'shoot',
                              _repo.shoot,
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('SHOOT'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isConnected
                        ? () => _run(
                              'stop',
                              _repo.stop,
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('STOP'),
                  ),
                ),
              ],
            ),

            const Divider(),

            // ==================================================
            // LOG
            // ==================================================

            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Text(
                  _log,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SLIDER
  // ============================================================

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label: ${value.toStringAsFixed(1)}',
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: _isConnected ? onChanged : null,
          ),
        ),
      ],
    );
  }
}
