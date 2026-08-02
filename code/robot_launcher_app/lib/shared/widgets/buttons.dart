import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:robot_launcher_app/shared/constants/colors.dart';

class GreenButton extends StatelessWidget {
  const GreenButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.iconPath
  });
  final String text;
  final VoidCallback onPressed;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Values.buttonPadding),
      child: FractionallySizedBox(
      widthFactor: Values.buttonWidthFactor,
      child: SizedBox(
        height: Values.buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palet.primaryAccent,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Values.buttonFontSize,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Values.buttonCurve),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
              ),
              const SizedBox(width: Values.buttonInnerSpacing),
              Text(
                text,
                style: TextStyle(color: Palet.primaryText),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}

class RedButton extends StatelessWidget {
    const RedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.iconPath
  });
  final String text;
  final VoidCallback onPressed;
  final String iconPath;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Values.buttonPadding),
      child: FractionallySizedBox(
      widthFactor: Values.buttonWidthFactor,
      child: SizedBox(
        height: Values.buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palet.error,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Values.buttonFontSize,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Values.buttonCurve),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
              ),
              const SizedBox(width: Values.buttonInnerSpacing),
              Text(
                text, 
                style: TextStyle(color: Palet.secondaryPanels))
            ],
          ),
        )
      ),
    ),
    );
  }
}

class WhiteButton extends StatelessWidget {
  const WhiteButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed
  });
  final String text;
  final VoidCallback onPressed;
  final String iconPath;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palet.error,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Values.buttonFontSize,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Values.buttonCurve),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
          ),
          const SizedBox(width: Values.buttonInnerSpacing),
          Text(
            text, 
            style: TextStyle(color: Palet.secondaryPanels))
        ],
      ),
    );
  }
}