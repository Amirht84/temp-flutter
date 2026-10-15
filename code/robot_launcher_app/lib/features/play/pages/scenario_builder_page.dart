import 'package:flutter/material.dart';
import 'package:robot_launcher_app/features/app_shell/mode_view_model.dart';
import 'package:robot_launcher_app/features/play/widgets/delay_slider_card.dart';
import 'package:robot_launcher_app/features/play/widgets/spin_card.dart';
import 'package:robot_launcher_app/features/play/widgets/tennis_court_card.dart';
import 'package:robot_launcher_app/features/play/widgets/text_field_card.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';
import 'package:robot_launcher_app/shared/widgets/tab.dart';

const double buttonWidth = 150;

class ScenarioBuilderPage extends StatefulWidget {
  const ScenarioBuilderPage({super.key, required this.modeViewModel});
  final ModeViewModel modeViewModel;
  @override
  State<StatefulWidget> createState() => _ScenarioBuilderPageState();
}

class _ScenarioBuilderPageState extends State<ScenarioBuilderPage> {
  late Position? _selectedTab;
  @override
  void initState() {
    _selectedTab = null;
    super.initState();
  }

  void _onTabPressed(Position position) {
    setState(() {
      if (_selectedTab == position) {
        _selectedTab = null;
      } else {
        _selectedTab = position;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Palet.secondBackground),
      body: PopScope(
        canPop: _selectedTab == null,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _selectedTab != null) {
            setState(() => _selectedTab = null);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.bodyPadding),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Align(
                      alignment: .center,
                      child: SizedBox(width: 300, child: TennisCourtCard()),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: AppTab(
                        position: .right,
                        isSelected: _selectedTab == .right,
                        icon: Icons.build,
                        onPressed: () => _onTabPressed(.right),
                        child: Center(child: Text('gadgets will be here')),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: AppTab(
                        position: .left,
                        onPressed: () => _onTabPressed(.left),
                        isSelected: _selectedTab == .left,
                        icon: Icons.file_copy,
                        child: Column(
                          mainAxisAlignment: .spaceAround,
                          children: [
                            TextFieldCard(),
                            WhiteButton(text: 'Run', onPressed: () {}),
                            WhiteButton(text: 'Draft', onPressed: () {}),
                            GreenButton(text: 'Save', onPressed: () {}),
                            RedButton(text: 'Delete', onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              EmptyDivider(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.bodyPadding,
                ),
                child: Column(
                  children: [
                    SpinCard(),
                    EmptyDivider(),
                    DelaySliderCard(onChangedEnd: (_) {}),
                    EmptyDivider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          height: 100,
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Palet.cards,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            
            boxShadow: [
          BoxShadow(blurRadius: 8, color: Palet.shadow, offset: Offset(0, 3)),

]
          ),
          child: Row(
            mainAxisAlignment: .spaceEvenly,
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                width: buttonWidth,
                child: RedButton(text: 'Delete Shot', onPressed: () {}),
              ),

              SizedBox(
                width: buttonWidth,
                child: GreenButton(
                  text: 'New Shot',
                  onPressed: () {},
                  iconPath: AppAssets.newCross,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
