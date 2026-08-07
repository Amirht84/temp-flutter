import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/ble_service.dart';
import '../../core/robot_controller.dart';
import '../../shared/constants/themes.dart';
import '../manual/manual_page.dart';

class BleScanPage extends StatefulWidget {
  const BleScanPage({super.key});

  @override
  State<BleScanPage> createState() => _BleScanPageState();
}

class _BleScanPageState extends State<BleScanPage> {
  final _bleService = BleService();
  List<DiscoveredDevice> _devices = [];
  bool _isScanning = false;
  String? _connectingId;

  @override
  void initState() {
    super.initState();
    _bleService.devicesStream.listen((devices) {
      if (mounted) setState(() => _devices = devices);
    });
  }

  Future<void> _requestPermissionsAndScan() async {
    // Android 12+ needs BLUETOOTH_SCAN + BLUETOOTH_CONNECT; older needs location.
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    final allGranted = statuses.values.every(
      (s) => s == PermissionStatus.granted || s == PermissionStatus.limited,
    );
    if (!allGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bluetooth & Location permissions are required'),
          ),
        );
      }
      return;
    }

    setState(() {
      _isScanning = true;
      _devices = [];
    });
    _bleService.startScan();

    // Auto-stop scan after 10 seconds.
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isScanning) {
        _bleService.stopScan();
        setState(() => _isScanning = false);
      }
    });
  }

  Future<void> _connectTo(DiscoveredDevice device) async {
    _bleService.stopScan();
    setState(() {
      _isScanning = false;
      _connectingId = device.id;
    });
    try {
      await _bleService.connect(device.id);
      if (!mounted) return;
      final controller = RobotController(_bleService);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ManualPage(controller: controller)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _connectingId = null);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Connection failed: $e')));
    }
  }

  @override
  void dispose() {
    _bleService.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Palet.secondBackground,
        title: const Text('Select Robot'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palet.primaryAccent,
            ),
            onPressed: _isScanning ? null : _requestPermissionsAndScan,
            icon: _isScanning
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.bluetooth_searching),
            label: Text(_isScanning ? 'Scanning…' : 'Scan for Devices'),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _devices.isEmpty
                ? Center(
                    child: Text(
                      _isScanning
                          ? 'Looking for devices…'
                          : 'No devices found.\nTap Scan to start.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Palet.secondaryText),
                    ),
                  )
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (_, i) {
                      final d = _devices[i];
                      final isConnecting = _connectingId == d.id;
                      return ListTile(
                        leading: const Icon(Icons.bluetooth),
                        title: Text(d.name.isEmpty ? '(unknown)' : d.name),
                        subtitle: Text(d.id),
                        trailing: isConnecting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                '${d.rssi} dBm',
                                style: const TextStyle(
                                  color: Palet.secondaryText,
                                ),
                              ),
                        onTap: isConnecting ? null : () => _connectTo(d),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
