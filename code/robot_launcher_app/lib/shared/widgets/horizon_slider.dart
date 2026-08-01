import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/colors.dart';

class HorizonSlider extends StatefulWidget {
  const HorizonSlider(
    {
      super.key,
      required this.minValue,
      required this.maxValue,
      required this.title,
    });

  final double minValue;
  final double maxValue;
  final String title;
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
            value.toInt().toString(),
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
                Text(widget.minValue.toInt().toString()),
                Text(widget.maxValue.toInt().toString()),
              ],
            ),
          ),
        ],
      )
    );
  }
}