import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.cardPadding),
      decoration: BoxDecoration(
        color: Palet.cards,
        borderRadius: BorderRadius.circular(Dimensions.circularRadius),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Palet.shadow, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}
