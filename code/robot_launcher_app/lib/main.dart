import 'package:flutter/material.dart';
import 'features/main/main.dart';
import 'features/manual/manual.dart';
import 'features/home/home.dart';
import 'package:robot_launcher_app/shared/constants/dictie.dart';
import 'shared/widgets/buttons.dart';
import 'shared/widgets/sliders.dart';
import 'shared/widgets/dividers.dart';
import 'shared/constants/assets.dart';
import 'shared/constants/themes.dart';
import 'package:rotary_knob/rotary_knob.dart';
import 'shared/widgets/rotary_knob.dart';

void main() {
  runApp(const MainApp());
}

/*
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TempTemp(),
        ),
      )
    );
  }
}

class TempTemp extends StatefulWidget {
  const TempTemp({super.key});

  @override State<TempTemp> createState() => _TempTempState();
}

class _TempTempState extends State<TempTemp> {
  late double value;
  @override void initState() {
    value = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(value.toInt().toString()),
        SizedBox(
          width: 300,
          height: 300,
          child: RotaryKnob(
            value: value,
            minValue: -25,
            maxValue: 25,
            startAngle: -135,
            sweepAngle: 90,
            step: 1,
            onChanged: (newValue) => setState(() => value = newValue),
            style: const RotaryKnobStyle(
              normal: RotaryKnobAppearance(
                surfaceColor: Palet.cards,
                boundryColor: Palet.primaryAccent,
                indicatorColor: Palet.primaryAccent,
                majorDivisions: 2,
                minorDivisions: 10,
              ),
              pressed: RotaryKnobAppearance(
                surfaceColor: Palet.cards,
                boundryColor: Palet.primaryAccent,
                indicatorColor: Palet.primaryAccent,
                innerCircleFactor: 0.23,
                majorDivisions: 2,
                minorDivisions: 10,
                indicatorWidth: 6,
                shadowBlurRadius: 12,
                innerBorderFactor: 0.47)
            ))
    )
    ]);
  }
}*/

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}
