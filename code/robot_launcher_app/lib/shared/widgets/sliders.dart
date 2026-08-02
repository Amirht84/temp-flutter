import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/colors.dart';

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
    return Center(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      
          Text(
              widget.title,
              style: TextStyle(
                fontSize: Values.sliderTitleSize,
                fontWeight: FontWeight.bold)
            ),
          Text(
            '${value.toInt()}${widget.unit}',
            style: TextStyle(
              fontSize: Values.sliderValueSize,
              fontWeight: FontWeight.bold,
            )
          ),
          _ExpandedOrNot(
            isExpanded: widget.isVertical,
          child: _Slider(
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
          ),)
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
  List<Text> get _children => [
    Text('${minValue.toInt()}$unit'),
    Text('${maxValue.toInt()}$unit'),
  ];
  @override
  Widget build(BuildContext context) {

    return FractionallySizedBox(
      widthFactor: isVertical ? null : Values.sliderFactor,
      heightFactor: isVertical ? Values.sliderFactor : null,

      child: Padding(
        padding: isVertical 
          ? EdgeInsets.only(
              bottom: Values.sliderPadding
            ) 
          : EdgeInsets.only(
              top: Values.sliderPadding,
              bottom: Values.sliderBoundOffset,
              left: Values.sliderPadding,
              right: Values.sliderPadding
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
            
            offset: isVertical ? Offset(Values.sliderBoundOffset, 0) : Offset(0, Values.sliderBoundOffset),
            child: isVertical 
              ? Column(children: _children, mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,)
              : Row(children: _children,mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          )
        ],
      ),)
    );
  }
}

class _ExpandedOrNot extends StatelessWidget {
  const _ExpandedOrNot({
    required this.child,
    this.isExpanded = false,
  });
  final Widget child;
  final bool isExpanded;

  @override
  Widget build(BuildContext _) {
    return isExpanded ? Expanded(child: child) : child;
  }
}