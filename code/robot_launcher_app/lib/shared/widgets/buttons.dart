import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

class GreenButton extends StatelessWidget {
  const GreenButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.iconPath,
    this.isDisabled = false,
  });
  final String text;
  final VoidCallback onPressed;
  final String iconPath;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.buttonPadding),
      child: FractionallySizedBox(
        widthFactor: Dimensions.buttonWidthFactor,
        child: SizedBox(
          height: Dimensions.buttonHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDisabled
                ? Palet.disabled
                : Palet.primaryAccent,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.buttonFontSize,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dimensions.buttonCurve,
                ),
              ),
              overlayColor: Colors.transparent,
            ),
            onPressed: isDisabled ? null : onPressed,
            child: _ButtonContext(
              text: text,
              iconPath: iconPath,
              color: Palet.primaryText,
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
      padding: EdgeInsets.symmetric(vertical: Dimensions.buttonPadding),
      child: FractionallySizedBox(
      widthFactor: Dimensions.buttonWidthFactor,
      child: SizedBox(
        height: Dimensions.buttonHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palet.error,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.buttonFontSize,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.buttonCurve),
            ),
          ),
          onPressed: onPressed,
          child: _ButtonContext(
            text: text,
            iconPath: iconPath, 
            color: Palet.secondaryPanels
          )
        )
      ),
    ),
    );
  }
}

class _ButtonContext extends StatelessWidget {
  const _ButtonContext({
    required this.text,
    required this.iconPath,
    required this.color,
  });
  final String text;
  final String iconPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.buttonContextSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            iconPath
          ),
          Text(
            text,
            style: TextStyle(color: color),
          )
        ],
      ),
    );
  }
}
/*
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
          fontSize: Dimensions.buttonFontSize,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.buttonCurve),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
          ),
          const SizedBox(width: Dimensions.buttonContextSize),
          Text(
            text, 
            style: TextStyle(color: Palet.secondaryPanels))
        ],
      ),
    );
  }
}*/