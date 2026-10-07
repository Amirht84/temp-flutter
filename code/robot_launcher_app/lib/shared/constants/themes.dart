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
  static const border = Color(0xFFB8BEC6);
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
  static const pending = Color(0xFFF5C542);
}

abstract final class Dimensions {
  ////////////BODY////////////
  static const bodyPadding = 10.0;
  ////////////SLIDERS////////////
  static const double valueControlTitleSize = 15.0;
  static const double valueControlValueSize = 22.0;
  static const double valueControlFactor = 0.9;
  static const double sliderPadding = 10.0;
  static const double sliderBoundOffset = 25.0;

  ////////////BUTTONS////////////
  static const double buttonCurve = 14.0;
  static const double buttonNormalFontSize = 18.0;
  static const double buttonSelectionFontSize = 10.0;
  static const double buttonContextSize = 125.0;
  static const double buttonNormalHeight = 50.0;
  static const double buttonSelectionHeight = 70.0;
  static const double buttonWidthFactor = 1.0;
  static const double buttonPadding = 5.0;
  static const double buttonSvgHeight = 35.0;
  static const double buttonEntryHeight = 50.0;
  static const double buttonEntryTitleSize = 15;
  static const double buttonEntryDescSize = 12.0;
  static const double buttonEntryVerticPadding = 5.0;
  static const double buttonEntryHorizonPadding = 10.0;

  ////////////DIVIDERS////////////
  static const double dividerSize = 30.0;
  static const double dividerNarrowThickness = 1.0;
  static const double dividerWideThickness = 2.0;
  static const double dividerFactor = 0.9;
  static const double emptyDividerSize = 10.0;

  ////////////Radio////////////
  static const double radioMainCircleFactor = 0.8;
  static const double radioTickMarkFactor = 0.85;
  static const double radioNarrowTickMarkFactor = 0.95;
  static const double radioNarrowCircleFactor = 0.5;
  static const double radioInnerCircleFactor = 0.25;
  static const double radioArmThickness = 7.0;

  static const double titleContextSize = 10.0;

  //////////// CARD ////////////
  static const double cardTitleSize = 15.0;
  static const double circularRadius = 16.0;
  static const double cardPadding = 10.0;
}
