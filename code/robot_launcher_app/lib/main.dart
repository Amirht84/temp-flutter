import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/dictie.dart';
import 'shared/widgets/buttons.dart';
import 'shared/widgets/sliders.dart';
import 'shared/constants/colors.dart';
import 'shared/widgets/dividers.dart';
import 'shared/constants/assets.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Palet.secondBackground,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: Palet.success
              ),
              Text("Connected"),
            ],),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: Values.bodyPadding),
          child: ManualPage(),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            selectedItemColor: Palet.pressed,
            unselectedItemColor: Palet.disabled,
            backgroundColor: Palet.secondBackground,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'settings'
              )
            ],)
        )
      ),
    );
  }
}

class ManualPage extends StatelessWidget {
  const ManualPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlexibleSlider(
          minValue: 0,
          maxValue: 100,
          title: 'Up Wheel Speed',
          unit: Units.rpm),
        HorizonDivider(),
        FlexibleSlider(
          minValue: 0,
          maxValue: 100,
          title: 'Down Wheel Speed',
          unit: Units.rpm,
        ),
        HorizonDivider(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
              child: FlexibleSlider(
                isVertical: true,
                minValue: 0,
                maxValue: 100,
                title: 'Hirizontal Degree',
              )),
              VerticDivider(),
              Expanded(
                flex: 1,
              child: FlexibleSlider(
                isVertical: true,
                minValue: 0,
                maxValue: 100,
                title: 'Vertical Degree'),)
            ],
          ),
        ),
        GreenButton(
          iconPath: AppAssets.tennisBall,
          text: "Launch!",
          onPressed: () => 0
        ),
        RedButton(
          iconPath: AppAssets.stop,
          text: "Stop!",
          onPressed: () => 0
        )
      ],
    );
  }
}