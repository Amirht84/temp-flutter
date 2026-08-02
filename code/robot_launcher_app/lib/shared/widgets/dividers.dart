import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/colors.dart';

class HorizonDivider extends StatelessWidget {
  const HorizonDivider({super.key});

  @override
  Widget build(BuildContext _) {
    return FractionallySizedBox(
      widthFactor: Values.dividerFactor,
      child: Divider(
        color: Palet.divider,
        thickness: Values.dividerThickness,
        height: Values.dividerSize)
    );
  }
}

class VerticDivider extends StatelessWidget {
  const VerticDivider({super.key});

  @override
  Widget build(BuildContext _){
    return FractionallySizedBox(
      heightFactor: Values.dividerFactor,
      child: VerticalDivider(
        color: Palet.divider,
        thickness: Values.dividerThickness,
        width: Values.dividerSize
      ), 
    );
  }
}