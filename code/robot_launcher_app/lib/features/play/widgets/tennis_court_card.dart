import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:tennis_court/tennis_court.dart';

class TennisCourtCard extends StatelessWidget {
  const TennisCourtCard({
    super.key,
    this.isDisabled = false,
  });
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: TennisCourt(
        padding: EdgeInsets.all(15),
        borderRadius: BorderRadius.circular(Dimensions.circularRadius),
        colors: isDisabled
          ? TennisCourtColors(court: Palet.disabled, selected: Colors.transparent)
          : TennisCourtColors(),
        onToggleSelection: isDisabled ? null :(value) {/** to be implemented */},
      ));
  }
}