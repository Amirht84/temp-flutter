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
    return _ActionButton(
      text: text,
      onPressed: onPressed,
      iconPath: iconPath,
      isDisabled: isDisabled,
      backgroundColor: Palet.primaryAccent,
      disabledColor: Palet.disabled,
      contextColor: Palet.primaryText,
    );
  }
}

class RedButton extends StatelessWidget {
  const RedButton({
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
    return _ActionButton(
      text: text,
      onPressed: onPressed,
      iconPath: iconPath,
      isDisabled: isDisabled,
      backgroundColor: Palet.error,
      disabledColor: Palet.disabled,
      contextColor: Palet.secondaryPanels,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.text,
    required this.onPressed,
    required this.iconPath,
    required this.backgroundColor,
    required this.disabledColor,
    required this.contextColor,
    required this.isDisabled,
  });

  final String text;
  final VoidCallback onPressed;
  final String iconPath;
  final Color backgroundColor;
  final Color disabledColor;
  final Color contextColor;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(Dimensions.buttonCurve);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.buttonPadding),
      child: FractionallySizedBox(
        widthFactor: Dimensions.buttonWidthFactor,
        child: Container(
          height: Dimensions.buttonHeight,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: isDisabled
                ? null
                : const [
                    BoxShadow(
                      color: Palet.shadow,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: isDisabled ? disabledColor : backgroundColor,

              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.buttonFontSize,
              ),
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
            onPressed: isDisabled ? null : onPressed,
            child: _ButtonContext(
              text: text,
              iconPath: iconPath,
              color: isDisabled ? Palet.primaryText : contextColor,
            ),
          ),
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
            iconPath,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          Text(text, style: TextStyle(color: color)),
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
