import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/widgets/texts.dart';

class FlexibleSlider extends StatefulWidget {
  const FlexibleSlider({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.title,
    required this.onChangedEnd,
    this.isVertical = false,
    this.isDisabled = false,
    this.unit = "",
  });

  final double minValue;
  final double maxValue;
  final String title;
  final bool isVertical;
  final String unit;
  final bool isDisabled;
  final ValueChanged<double> onChangedEnd;

  @override
  State<FlexibleSlider> createState() => _FlexibleSliderState();
}

class _FlexibleSliderState extends State<FlexibleSlider> {
  late double value;
  @override
  void initState() {
    super.initState();
    value = widget.minValue;
  }

  @override
  Widget build(BuildContext context) {
    final slider = _Slider(
      minValue: widget.minValue,
      maxValue: widget.maxValue,
      value: value,
      isVertical: widget.isVertical,
      onChanged: (newValue) {
        setState(() {
          value = newValue;
        });
      },
      isDisabled: widget.isDisabled,
      onChangedEnd: widget.onChangedEnd,
      unit: widget.unit,
    );

    return Column(
      mainAxisSize: widget.isVertical ? MainAxisSize.max : MainAxisSize.min,
      children: [
        TitleText(widget.title),
        ValueText('${value.toInt()}${widget.unit}'),
        widget.isVertical ? Expanded(child: slider) : slider,
      ],
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.value,
    this.isDisabled = false,
    this.unit = "",
    this.isVertical = false,
    required this.onChangedEnd,
  });
  final double minValue;
  final double maxValue;
  final String unit;
  final double value;
  final ValueChanged<double> onChanged;
  final bool isVertical;
  final ValueChanged<double> onChangedEnd;
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: isVertical ? null : Dimensions.valueControlFactor,
      heightFactor: isVertical ? Dimensions.valueControlFactor : null,

      child: Padding(
        padding: isVertical
            ? EdgeInsets.only(bottom: Dimensions.sliderPadding)
            : EdgeInsets.only(
                top: Dimensions.sliderPadding,
                bottom: Dimensions.sliderBoundOffset,
                left: Dimensions.sliderPadding,
                right: Dimensions.sliderPadding,
              ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            RotatedBox(
              quarterTurns: isVertical ? 3 : 0,
              child: Slider(
                onChangeEnd: isDisabled ? null : onChangedEnd,
                padding: EdgeInsets.zero,
                value: value,
                min: minValue,
                max: maxValue,
                activeColor: isDisabled ? Palet.disabled : Palet.primaryAccent,
                onChanged: isDisabled ? null : onChanged,
              ),
            ),
            Transform.translate(
              offset: isVertical
                  ? Offset(Dimensions.sliderBoundOffset, 0)
                  : Offset(0, Dimensions.sliderBoundOffset),
              child: Flex(
                verticalDirection: VerticalDirection.up,
                direction: isVertical ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${minValue.toInt()}$unit'),
                  Text('${maxValue.toInt()}$unit'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
