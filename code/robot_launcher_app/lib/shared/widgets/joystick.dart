import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/painters/joystick_paint.dart';
import 'package:robot_launcher_app/shared/widgets/texts.dart';

class JoystickCard extends StatefulWidget {
  const JoystickCard({
    super.key,
    required this.title,
    required this.onChanged,
    this.onChangedEnd,
    this.isDisabled = false,
    this.mode = JoystickMode.all,
  });

  final String title;
  final void Function(double x, double y) onChanged;
  final void Function(double x, double y)? onChangedEnd;
  final bool isDisabled;
  final JoystickMode mode;

  @override
  State<JoystickCard> createState() => _JoystickCardState();
}

class _JoystickCardState extends State<JoystickCard> {
  double _x = 0;
  double _y = 0;

  void _handleJoystickChanged(double x, double y) {
    _x = x;
    _y = y;

    widget.onChanged(x, y);
  }

  void _handleJoystickEnd() {
    widget.onChangedEnd?.call(_x, _y);

    setState(() {
      _x = 0;
      _y = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TitleText(widget.title),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.buttonPadding),
            child: FractionallySizedBox(
              widthFactor: Dimensions.valueControlFactor,
              child: AspectRatio(
                aspectRatio: 1,
                child: AbsorbPointer(
                  absorbing: widget.isDisabled,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final joystickSize = constraints.biggest.shortestSide;

                      return Joystick(
                        mode: widget.mode,
                        includeInitialAnimation: !widget.isDisabled,

                        listener: (details) {
                          _handleJoystickChanged(details.x, details.y);
                        },

                        onStickDragEnd: _handleJoystickEnd,

                        base: SizedBox.expand(
                          child: CustomPaint(
                            painter: JoystickPainter(
                              appearance: JoystickAppearance(),
                            ),
                          ),
                        ),

                        stick: JoystickStick(
                          size: joystickSize * 0.22,
                          decoration: JoystickStickDecoration(
                            color: widget.isDisabled
                                ? Palet.disabled
                                : Palet.primaryAccent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
