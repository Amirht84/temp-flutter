import 'package:flutter/material.dart';
import 'package:tennis_court/tennis_court.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 300, height: 500, child: TennisCourt(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20)
          )),
        ),
      ),
    );
  }
}
