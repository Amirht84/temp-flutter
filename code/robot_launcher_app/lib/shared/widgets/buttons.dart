import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

enum Mode {
  normal,
  selection,
}

class GreenButton extends StatelessWidget {
  const GreenButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath,
    this.isDisabled = false,
    this.hasShadow = true,
    this.mode = .normal,
  });

  final String text;
  final VoidCallback onPressed;
  final String? iconPath;
  final bool isDisabled;
  final bool hasShadow;
  final Mode mode;

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
      shadowColor: hasShadow ? Palet.shadow : Colors.transparent,
      mode: mode,
    );
  }
}

class RedButton extends StatelessWidget {
  const RedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath,
    this.isDisabled = false,
    this.hasShadow = true,
    this.mode = .normal,
  });

  final String text;
  final VoidCallback onPressed;
  final String? iconPath;
  final bool isDisabled;
  final bool hasShadow;
  final Mode mode;

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
      shadowColor: hasShadow ? Palet.shadow : Colors.transparent,
      mode: mode,
    );
  }
}

class WhiteButton extends StatelessWidget {
  const WhiteButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath,
    this.isDisabled = false,
    this.hasShadow = true,
    this.mode = .normal,
  });

  final String text;
  final VoidCallback onPressed;
  final String? iconPath;
  final bool isDisabled;
  final bool hasShadow;
  final Mode mode;

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      text: text,
      onPressed: onPressed,
      iconPath: iconPath,
      isDisabled: isDisabled,
      backgroundColor: Colors.white,
      disabledColor: Palet.disabled,
      contextColor: Palet.primaryText,
      borderColor: Palet.border,
      shadowColor: hasShadow ? Palet.shadow : Colors.transparent,
      mode: mode,
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
    this.borderColor,
    required this.shadowColor,
    required this.mode,
  });

  final String text;
  final VoidCallback onPressed;
  final String? iconPath;
  final Color backgroundColor;
  final Color disabledColor;
  final Color contextColor;
  final bool isDisabled;
  final Color shadowColor;
  final Color? borderColor;
  final Mode mode;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(Dimensions.buttonCurve);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.buttonPadding,
      ),
      child: FractionallySizedBox(
        widthFactor: Dimensions.buttonWidthFactor,
        child: Container(
          height: mode == .normal ? Dimensions.buttonNormalHeight : Dimensions.buttonSelectionHeight,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: isDisabled
                  ? disabledColor
                  : backgroundColor,
              textStyle: TextStyle(
                fontWeight: mode == .normal ? FontWeight.bold : FontWeight.normal,
                fontSize: mode == .normal ? Dimensions.buttonNormalFontSize : Dimensions.buttonSelectionFontSize,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: borderColor == null
                    ? BorderSide.none
                    : BorderSide(color: borderColor!),
              ),
            ),
            onPressed: isDisabled ? null : onPressed,
            child: _ButtonContext(
              text: text,
              iconPath: iconPath,
              color: isDisabled
                  ? Palet.primaryText
                  : contextColor,
              mode: mode,
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
    required this.mode,
  });

  final String text;
  final String? iconPath;
  final Color color;
  final Mode mode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.buttonContextSize,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: mode == .selection ? 5 : 0
        ),
        child: Flex(
        direction: mode == .normal ? .horizontal : .vertical,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if(iconPath != null )
            SvgPicture.asset(
              iconPath!,
              height: mode == .selection ? Dimensions.buttonSvgHeight : null,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          Text(text, style: TextStyle(color: color)),
        ],
        ),
      )
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
