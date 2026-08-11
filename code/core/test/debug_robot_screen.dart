// ============================================================
// FILE: test/debug_robot_screen.dart
// A throwaway test harness — NOT the real UI your friend is
// building. Just enough controls to prove the real BLE path
// (FlutterBluePlusService -> BleRepository) works against an
// actual robot, independent of any ViewModel or final UI.
//
// Run it on a physical phone with:
//   flutter run -t test/main_debug.dart
// ============================================================

import 'package:flutter/material.dart';

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

  final List<BleDevice> _found = [];
  BleDevice? _connected;
  bool _isConnected = false;
  bool _isScanning = false;
  RobotState _state = RobotState.initial;
  String _log = '';

  double _topRpm = 0, _bottomRpm = 0;
  double _angleH = 0, _angleV = 0;
  double _joyX = 0, _joyY = 0;

  @override
  void initState() {
    super.initState();
    _ble = FlutterBluePlusService();
    _repo = BleRepository(bleService: _ble);

    _repo.connectionStream.listen((connected) {
      setState(() => _isConnected = connected);
      _appendLog(connected ? 'connected' : 'disconnected');
    });
    _repo.robotStateStream.listen((state) {
      setState(() => _state = state);
    });
  }

  void _appendLog(String line) {
    setState(() => _log = '$line\n$_log');
  }

  Future<void> _scan() async {
    try {
      await _ble.ensureBluetoothOn();
    } catch (e) {
      _appendLog('❌ $e');
      return;
    }
    setState(() {
      _found.clear();
      _isScanning = true;
    });
    _repo.scanForRobots().listen(
      (device) => setState(() => _found.add(device)),
      onDone: () => setState(() => _isScanning = false),
      onError: (e) {
        _appendLog('❌ scan error: $e');
        setState(() => _isScanning = false);
      },
    );
  }

  Future<void> _connect(BleDevice device) async {
    try {
      _appendLog('connecting to ${device.name}...');
      await _repo.connectToRobot(device);
      setState(() => _connected = device);
    } catch (e) {
      _appendLog('❌ connect failed: $e');
    }
  }

  Future<void> _disconnect() async {
    await _repo.disconnectFromRobot();
    setState(() => _connected = null);
  }

  Future<void> _run(String label, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      _appendLog('❌ $label failed: $e');
    }
  }

  @override
  void dispose() {
    _repo.dispose();
    _ble.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Robot BLE — Real Hardware Test')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(_isConnected ? 'Connected' : 'Not connected'),
                const Spacer(),
                if (_connected == null)
                  ElevatedButton(
                    onPressed: _isScanning ? null : _scan,
                    child: Text(_isScanning ? 'Scanning...' : 'Scan'),
                  )
                else
                  OutlinedButton(
                    onPressed: _disconnect,
                    child: const Text('Disconnect'),
                  ),
              ],
            ),
            if (_connected == null && _found.isNotEmpty)
              SizedBox(
                height: 140,
                child: ListView.builder(
                  itemCount: _found.length,
                  itemBuilder: (context, i) {
                    final d = _found[i];
                    return ListTile(
                      dense: true,
                      title: Text(d.name.isEmpty ? '(unnamed)' : d.name),
                      subtitle: Text('${d.id}  rssi: ${d.rssi}'),
                      trailing: ElevatedButton(
                        onPressed: () => _connect(d),
                        child: const Text('Connect'),
                      ),
                    );
                  },
                ),
              ),
            const Divider(),
            Text(
              'Last commanded: $_state',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _slider('Top RPM', _topRpm, 0, 100, (v) {
              setState(() => _topRpm = v);
              _run('setRpm', () => _repo.setRpm(v.round(), _bottomRpm.round()));
            }),
            _slider('Bottom RPM', _bottomRpm, 0, 100, (v) {
              setState(() => _bottomRpm = v);
              _run('setRpm', () => _repo.setRpm(_topRpm.round(), v.round()));
            }),
            _slider('Angle H', _angleH, -180, 180, (v) {
              setState(() => _angleH = v);
              _run('setAngleH', () => _repo.setAngleH(v));
            }),
            _slider('Angle V', _angleV, -45, 45, (v) {
              setState(() => _angleV = v);
              _run('setAngleV', () => _repo.setAngleV(v));
            }),
            _slider('Joystick X', _joyX, -1, 1, (v) {
              setState(() => _joyX = v);
              _run('joystick', () => _repo.joystick(v, _joyY));
            }),
            _slider('Joystick Y', _joyY, -1, 1, (v) {
              setState(() => _joyY = v);
              _run('joystick', () => _repo.joystick(_joyX, v));
            }),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isConnected
                        ? () => _run('shoot', _repo.shoot)
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
                        ? () => _run('stop', _repo.stop)
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
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _log,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          child: Text('$label: ${value.toStringAsFixed(1)}'),
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
