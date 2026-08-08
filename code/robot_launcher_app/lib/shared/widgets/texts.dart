import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText(
    this.data,
    {super.key}
  );
  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Dimensions.valueControlTitleSize
      )
    );
  }
}

class ValueText extends StatelessWidget {
  const ValueText(
    this.data,
    {super.key,}
  );
  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Dimensions.valueControlValueSize,
      )
    );
  }
}