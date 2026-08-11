import 'package:flutter/material.dart';


// static const secondBackground = Color(0xFFFAF7F2);
// static const secondBackground = Color(0xFFF8F1E7);
// static const secondBackground = Color(0xFFFFF8EE);

// static const secondBackground = Color(0xFFEFF1F3); ..
// static const secondBackground = Color(0xFFF1F2F0); ..

// static const secondBackground = Color(0xFFEAF2EE); ..
// static const secondBackground = Color(0xFFE8F3EC);

// static const secondBackground = Color(0xFFEFF4F7);
abstract final class Palet {
  static const shadow = Color(0x33000000);
  static const backGround = Color(0xFFF7F8FA);
  static const secondBackground = Color(0xFFE8F3EC);
  static const cards = Color(0xFFFFFFFF);
  static const secondaryPanels = Color(0xFFF2F4F7);
  static const border = Color(0xFFDDE2E8);
  static const divider = Color(0xFFCED4DB);
  static const primaryText = Color(0xFF1F2937);
  static const secondaryText = Color(0xFF6B7280);
  static const disabled = Color(0xFF9CA3AF);
  static const primaryAccent = Color(0xFFB9E937);
  static const hover = Color(0xFFA8D92C);
  static const pressed = Color(0xFF96C61F);
  static const success = Color(0xFF3CBF6B);
  static const warning = Color(0xFFF5A623);
  static const error = Color(0xFFE5484D);
  static const info = Color(0xFF3B82F6);
}

abstract final class Dimensions {
  ////////////BODY////////////
  static const bodyPadding = 10.0;
  ////////////SLIDERS////////////
  static const valueControlTitleSize = 15.0;
  static const valueControlValueSize = 22.0;
  static const valueControlFactor = 0.9;
  static const sliderPadding = 10.0;
  static const sliderBoundOffset = 25.0;

  ////////////BUTTONS////////////
  static const buttonCurve = 14.0;
  static const buttonFontSize = 18.0;
  static const buttonContextSize = 125.0;
  static const buttonHeight = 50.0;
  static const buttonWidthFactor = 0.9;
  static const buttonPadding = 5.0;

  ////////////DIVIDERS////////////
  static const dividerSize = 30.0;
  static const dividerNarrowThickness = 1.0;
  static const dividerWideThickness = 2.0;
  static const dividerFactor = 0.9;

  ////////////Radio////////////
  static const radioMainCircleFactor = 0.8;
  static const radioTickMarkFactor = 0.85;
  static const radioNarrowTickMarkFactor = 0.95;
  static const radioNarrowCircleFactor = 0.5;
  static const radioInnerCircleFactor = 0.25;
  static const radioArmThickness = 7.0;

  static const titleContextSize = 150.0;
}