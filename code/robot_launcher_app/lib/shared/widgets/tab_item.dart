import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/play/play_view_model.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';

const double tabItemHeight = 50;

class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.header});
  final ScenarioHeader header;
  String _timeFormat(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;
    final int hundredths = duration.inMilliseconds % 1000 ~/ 10;

    final minutesString = minutes != 0 ? '$minutes\':' : "";
    final secondsString = '$seconds"${minutes == 0 ? "." : ""}';
    final hundredthsString = minutes == 0
        ? hundredths.toString().padLeft(2, '0')
        : "";

    return '$minutesString$secondsString$hundredthsString';
  }

  @override
  Widget build(BuildContext context) {
    return WhiteEntry(
      title: header.title,
      firstDesc: 'time: ${_timeFormat(header.duration)}',
      secondDesc: 'shots: ${header.shots}',
      onPressed: () {},
    );
  }
}
