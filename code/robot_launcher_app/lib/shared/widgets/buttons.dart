import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

enum Mode { normal, selection }
enum _Mode {normal, selection, entry}
class GreenButton extends StatelessWidget {
  const GreenButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath,
    this.isDisabled = false,
    this.hasShadow = true,
    this.mode = .normal,
    this.hasBorder = false,
  });

  final String text;
  final VoidCallback onPressed;
  final String? iconPath;
  final bool isDisabled;
  final bool hasShadow;
  final Mode mode;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      onPressed: onPressed,
      isDisabled: isDisabled,
      backgroundColor: Palet.primaryAccent,
      disabledColor: Palet.disabled,
      shadowColor: hasShadow ? Palet.shadow : Colors.transparent,
      mode: switch(mode){
        .normal => .normal,
        .selection => .selection,
      },
      borderColor: hasBorder ? Palet.border : null,
      child: _ButtonContext(
        text: text,
        iconPath: iconPath,
        color: Palet.primaryText,
        mode: mode,
      ),
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
      onPressed: onPressed,
      isDisabled: isDisabled,
      backgroundColor: Palet.error,
      disabledColor: Palet.disabled,
      shadowColor: hasShadow ? Palet.shadow : Colors.transparent,
      mode: switch(mode) {
        .normal => .normal,
        .selection => .selection,
      },
      child: _ButtonContext(
        text: text,
        iconPath: iconPath,
        color: Colors.white,
        mode: mode,
      ),
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
      onPressed: onPressed,
      isDisabled: isDisabled,
      backgroundColor: Colors.white,
      disabledColor: Palet.disabled,
      borderColor: Palet.border,
      shadowColor: hasShadow ? Palet.shadow : Colors.transparent,
      mode: switch(mode) {
        .normal => .normal,
        .selection => .selection
      },
      child: _ButtonContext(
        text: text,
        iconPath: iconPath,
        color: Palet.primaryText,
        mode: mode,
      ),
    );
  }
}

class WhiteEntry extends StatelessWidget {
  const WhiteEntry({
    super.key,
    required this.title,
    required this.firstDesc,
    required this.secondDesc,
    required this.onPressed,
    this.isDisabled = false,
  });
  final String title;
  final String firstDesc;
  final String secondDesc;
  final VoidCallback onPressed;
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      mode: .entry,
      onPressed: onPressed,
      isDisabled: isDisabled,
      backgroundColor: Colors.white,
      disabledColor: Palet.disabled,
      borderColor: Palet.border,
      shadowColor: Palet.shadow,
      child: _EntryContext(
        title: title,
        firstDesc: firstDesc,
        secondDesc: secondDesc,
        contextColor: Palet.primaryText,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.disabledColor,
    required this.isDisabled,
    this.borderColor,
    required this.shadowColor,
    required this.mode,
    required this.child,
  });

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color disabledColor;
  final bool isDisabled;
  final Color shadowColor;
  final Color? borderColor;
  final _Mode mode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(Dimensions.buttonCurve);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.buttonPadding),
      child: FractionallySizedBox(
        widthFactor: Dimensions.buttonWidthFactor,
        child: Container(
          height: switch (mode) {
            .normal => Dimensions.buttonNormalHeight,
            .selection => Dimensions.buttonSelectionHeight,
            .entry => Dimensions.buttonEntryHeight,
          },
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
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: isDisabled ? disabledColor : backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: borderColor == null
                    ? BorderSide.none
                    : BorderSide(color: borderColor!),
              ),
            ),
            onPressed: isDisabled ? null : onPressed,
            child: child,
            ),
          ),
        ),
    );
  }
}

const constColor = Color(0xFF4F6F8F);

class _EntryContext extends StatelessWidget {
  const _EntryContext({
    required this.title,
    required this.firstDesc,
    required this.secondDesc,
    required this.contextColor,
  });
  final String title;
  final String firstDesc;
  final String secondDesc;
  final Color contextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.buttonEntryVerticPadding, horizontal: Dimensions.buttonEntryHorizonPadding), ///////////////////// ATTENTION
        child: Column(
          children: [
            Text(title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.buttonEntryTitleSize,
              color: contextColor,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(firstDesc,
                style: TextStyle(color: constColor, fontSize: Dimensions.buttonEntryDescSize)),
                Text(secondDesc, style: TextStyle(color: constColor, fontSize: Dimensions.buttonEntryDescSize)),
              ]
            )
          ]
        )
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: mode == .selection ? 5 : 0),
        child: Flex(
          direction: mode == .normal ? .horizontal : .vertical,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                height: mode == .selection ? Dimensions.buttonSvgHeight : null,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: switch (mode) {
                  .normal => FontWeight.bold,
                  .selection => FontWeight.normal,
                },
                fontSize: switch (mode) {
                  .normal => Dimensions.buttonNormalFontSize,
                  .selection => Dimensions.buttonSelectionFontSize,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}