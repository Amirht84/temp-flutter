import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

class FlexibleSlider extends StatefulWidget {
  const FlexibleSlider({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.title,
    this.isVertical = false,
    this.unit = ""
  });

  final double minValue;
  final double maxValue;
  final String title;
  final bool isVertical;
  final String unit;
  @override
  State<FlexibleSlider> createState() => _FlexibleSliderState();
}


class _FlexibleSliderState extends State<FlexibleSlider> {

  late double value;
  @override
  void initState() {
    super.initState();

    value = (widget.minValue + widget.maxValue) / 2;
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
      unit: widget.unit
    );


    return Center(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      
          Text(
              widget.title,
              style: TextStyle(
                fontSize: Dimensions.sliderTitleSize,
                fontWeight: FontWeight.bold)
            ),
          Text(
            '${value.toInt()}${widget.unit}',
            style: TextStyle(
              fontSize: Dimensions.sliderValueSize,
              fontWeight: FontWeight.bold,
            )
          ),
          widget.isVertical
            ? Expanded(child: slider)
            : slider,
        ],
      )
    );
  }  
}

class _Slider extends StatelessWidget {
  const _Slider ({
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.value,
    this.unit = "",
    this.isVertical = false
  });
  final double minValue;
  final double maxValue;
  final String unit;
  final double value;
  final ValueChanged<double> onChanged;
  final bool isVertical;
  @override
  Widget build(BuildContext context) {

    return FractionallySizedBox(
      widthFactor: isVertical ? null : Dimensions.sliderFactor,
      heightFactor: isVertical ? Dimensions.sliderFactor : null,

      child: Padding(
        padding: isVertical 
          ? EdgeInsets.only(
              bottom: Dimensions.sliderPadding
            ) 
          : EdgeInsets.only(
              top: Dimensions.sliderPadding,
              bottom: Dimensions.sliderBoundOffset,
              left: Dimensions.sliderPadding,
              right: Dimensions.sliderPadding
            ),
        child: Stack(
        alignment: Alignment.center,
        children:[
          RotatedBox(
            quarterTurns: isVertical ? 3 : 0,
            child: Slider(
              padding: EdgeInsets.zero,
              value: value,
              min: minValue,
              max: maxValue,
              activeColor: Palet.primaryAccent,
              onChanged: onChanged,
            ),
          ),
          Transform.translate(
            
            offset: isVertical ? Offset(Dimensions.sliderBoundOffset, 0) : Offset(0, Dimensions.sliderBoundOffset),
            child: Flex(
              verticalDirection: VerticalDirection.up,
              direction: isVertical ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${minValue.toInt()}$unit'),
                Text('${maxValue.toInt()}$unit'),
              ],
            )
          )
        ],
      ),)
    );
  }
}