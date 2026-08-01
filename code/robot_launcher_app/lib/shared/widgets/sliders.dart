import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/colors.dart';

class HorizonSlider extends StatefulWidget {
  const HorizonSlider(
    {
      super.key,
      required this.minValue,
      required this.maxValue,
      required this.title,
      this.unit = ""
    });

  final double minValue;
  final double maxValue;
  final String title;
  final String unit;
  @override
  State<HorizonSlider> createState() => _HorizonSliderState();

}

class _HorizonSliderState extends State<HorizonSlider> {

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold)
            ),
          ),
          Text(
            value.toInt().toString() + widget.unit,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            )
          ),
          Slider(
            value: value,
            min: widget.minValue,
            max: widget.maxValue,
            activeColor: Palet.primaryAccent,
            onChanged: (newValue) {
              setState((){
                value = newValue;
              });
            }
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.minValue.toInt().toString() + widget.unit),
                Text(widget.maxValue.toInt().toString() + widget.unit),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class VerticSlider extends StatefulWidget {
  const VerticSlider(
    {
      super.key,
      required this.minValue,
      required this.maxValue,
      required this.title,
      this.unit = "",
    });

  final double minValue;
  final double maxValue;
  final String title;
  final String unit;
  @override
  State<VerticSlider> createState() => _VerticSliderState();
}

class _VerticSliderState extends State<VerticSlider> {
  late double value;

  @override void initState() {
    super.initState();
    value = (widget.maxValue + widget.minValue) / 2;
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
              fontSize: 26,
              fontWeight: FontWeight.bold
            )
          ),
          Text(
            value.toInt().toString() + widget.unit,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            )
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    min: widget.minValue,
                    max: widget.maxValue,
                    value: value,
                    activeColor: Palet.primaryAccent,
                    onChanged: (newValue) {
                      setState(() {
                        value = newValue;
                      });
                    },                
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Transform.translate(
                    offset: const Offset(40, 0),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.maxValue.toInt().toString() + widget.unit),
                      Text(widget.minValue.toInt().toString() + widget.unit),
                    ],),
                  )
                )


              ],
            ),
          )
        ],
      )
    );
  }

}