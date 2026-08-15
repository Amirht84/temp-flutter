import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import '../app_shell_view_model.dart';

/// Modal sheet that scans for nearby BLE devices and lets the user
/// manually pick the one to connect to — mirroring the flow from
/// the real-hardware debug harness (scan, show a list, tap to
/// connect), but styled to match the rest of the app.
class DevicePickerSheet extends StatefulWidget {
  const DevicePickerSheet({super.key, required this.viewModel});

  final AppShellViewModel viewModel;

  /// Convenience helper to present this sheet.
  static Future<void> show(BuildContext context, AppShellViewModel viewModel) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Palet.cards,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DevicePickerSheet(viewModel: viewModel),
    );
  }

  @override
  State<DevicePickerSheet> createState() => _DevicePickerSheetState();
}

class _DevicePickerSheetState extends State<DevicePickerSheet> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
    widget.viewModel.startScan();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    if (widget.viewModel.isConnected) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    widget.viewModel.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: widget.viewModel,
        builder: (context, _) {
          final viewModel = widget.viewModel;

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Connect to Robot',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (viewModel.isScanning)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Scan again',
                        onPressed: viewModel.startScan,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Palet.error),
                    ),
                  ),
                Flexible(child: _buildDeviceList(viewModel)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeviceList(AppShellViewModel viewModel) {
    if (viewModel.devices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            viewModel.isScanning
                ? 'Scanning for nearby devices...'
                : 'No devices found. Make sure the robot is powered on and in range.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Palet.secondaryText),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: viewModel.devices.length,
      separatorBuilder: (_, _) => const Divider(color: Palet.divider),
      itemBuilder: (context, index) {
        final device = viewModel.devices[index];
        final isConnectingThis = viewModel.isConnecting;

        return ListTile(
          leading: const Icon(Icons.bluetooth, color: Palet.info),
          title: Text(device.name.isEmpty ? '(unnamed device)' : device.name),
          subtitle: Text('${device.id}  •  rssi: ${device.rssi}'),
          trailing: isConnectingThis
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
          onTap: isConnectingThis
              ? null
              : () => viewModel.connectToDevice(device),
        );
      },
    );
  }
}
