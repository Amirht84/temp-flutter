import 'package:flutter/material.dart';
import '../../core/ble_service.dart';
import '../../core/robot_controller.dart';
import '../../shared/constants/assets.dart';
import '../../shared/constants/dictie.dart';
import '../../shared/constants/themes.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/dividers.dart';
import '../../shared/widgets/sliders.dart';

class ManualPage extends StatefulWidget {
  const ManualPage({super.key, required this.controller});
  final RobotController controller;

  @override
  State<ManualPage> createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  bool _isSending = false;

  Future<void> _onLaunch() async {
    if (_isSending) return;
    setState(() => _isSending = true);
    try {
      await widget.controller.launch();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Launch failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _onStop() async {
    try {
      await widget.controller.stop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Stop failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BleConnectionState>(
      stream: widget.controller.ble.connectionStream,
      initialData: BleConnectionState.connected,
      builder: (context, snapshot) {
        final connected = snapshot.data == BleConnectionState.connected;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Palet.secondBackground,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  color: connected ? Palet.success : Palet.error,
                ),
                const SizedBox(width: 6),
                Text(connected ? 'Connected' : 'Disconnected'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimensions.bodyPadding,
            ),
            child: _buildControls(),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BottomNavigationBar(
              selectedItemColor: Palet.pressed,
              unselectedItemColor: Palet.disabled,
              backgroundColor: Palet.secondBackground,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'settings',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    final ctrl = widget.controller;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlexibleSlider(
          minValue: 0,
          maxValue: 100,
          title: 'Up Wheel Speed',
          unit: Units.rpm,
          onChanged: (v) => ctrl.upWheelSpeed = v.toInt(),
        ),
        HorizonDivider(),
        FlexibleSlider(
          minValue: 0,
          maxValue: 100,
          title: 'Down Wheel Speed',
          unit: Units.rpm,
          onChanged: (v) => ctrl.downWheelSpeed = v.toInt(),
        ),
        HorizonDivider(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: FlexibleSlider(
                  isVertical: true,
                  minValue: 0,
                  maxValue: 180,
                  title: 'Horizontal Angle',
                  unit: Units.degree,
                  onChanged: (v) => ctrl.horizontalAngle = v.toInt(),
                ),
              ),
              VerticDivider(),
              Expanded(
                child: FlexibleSlider(
                  isVertical: true,
                  minValue: 0,
                  maxValue: 90,
                  title: 'Vertical Angle',
                  unit: Units.degree,
                  onChanged: (v) => ctrl.verticalAngle = v.toInt(),
                ),
              ),
            ],
          ),
        ),
        GreenButton(
          iconPath: AppAssets.tennisBall,
          text: _isSending ? 'Sending…' : 'Launch!',
          onPressed: _isSending ? () {} : _onLaunch,
        ),
        RedButton(iconPath: AppAssets.stop, text: 'Stop!', onPressed: _onStop),
      ],
    );
  }
}
