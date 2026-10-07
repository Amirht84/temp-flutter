import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

class HorizonDivider extends StatelessWidget {
  const HorizonDivider({super.key, this.hasPadding = true});
  final bool hasPadding;

  @override
  Widget build(BuildContext _) {
    return FractionallySizedBox(
      widthFactor: Dimensions.dividerFactor,
      child: Divider(
        color: Palet.divider,
        thickness: Dimensions.dividerNarrowThickness,
        height: hasPadding ? Dimensions.dividerSize : null,
      ),
    );
  }
}

class VerticDivider extends StatelessWidget {
  const VerticDivider({super.key, this.hasPadding = true});
  final bool hasPadding;

  @override
  Widget build(BuildContext _) {
    return FractionallySizedBox(
      heightFactor: Dimensions.dividerFactor,
      child: VerticalDivider(
        color: Palet.divider,
        thickness: Dimensions.dividerNarrowThickness,
        width: hasPadding ? Dimensions.dividerSize : null,
      ),
    );
  }
}

class EmptyDivider extends StatelessWidget {
  const EmptyDivider({super.key, this.isVertical = false});
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isVertical ? Dimensions.emptyDividerSize : null,
      height: isVertical ? null : Dimensions.emptyDividerSize,
    );
  }
}
