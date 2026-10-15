import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';
import 'package:robot_launcher_app/shared/widgets/texts.dart';

enum SpinType {
  flat,
  topSpin,
  slice,
  kick;

  @override
  String toString() {
    return switch (this) {
      .flat => 'Flat',
      .topSpin => 'TopSpin',
      .slice => 'Slice',
      .kick => 'Kick',
    };
  }
}

class SpinCard extends StatefulWidget {
  const SpinCard({super.key, this.isDisabled = false});
  final bool isDisabled;
  @override
  State<StatefulWidget> createState() => _SpinCardState();
}

class _SpinCardState extends State<SpinCard> {
  late SpinType selectedSpin;

  @override
  void initState() {
    selectedSpin = .flat;
    super.initState();
  }

  void _onToggle(SpinType spin) {
    setState(() {
      if (selectedSpin != spin) {
        selectedSpin = spin;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          TitleText("Spin"),
          EmptyDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SelectionButton(
                text: "Flat",
                isSelected: selectedSpin == .flat,
                onToggleSelection: _onToggle,
                spin: .flat,
                iconPath: AppAssets.flat,
                isDisabled: widget.isDisabled,
              ),
              EmptyDivider(isVertical: true),
              _SelectionButton(
                text: "TopSpin",
                isSelected: selectedSpin == .topSpin,
                onToggleSelection: _onToggle,
                spin: .topSpin,
                iconPath: AppAssets.topSpin,
                isDisabled: widget.isDisabled,
              ),
              EmptyDivider(isVertical: true),
              _SelectionButton(
                text: "Slice",
                isSelected: selectedSpin == .slice,
                onToggleSelection: _onToggle,
                spin: .slice,
                iconPath: AppAssets.slice,
                isDisabled: widget.isDisabled,
              ),
              EmptyDivider(isVertical: true),
              _SelectionButton(
                text: "Kick",
                isSelected: selectedSpin == .kick,
                onToggleSelection: _onToggle,
                spin: .kick,
                iconPath: AppAssets.kick,
                isDisabled: widget.isDisabled,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectionButton extends StatelessWidget {
  const _SelectionButton({
    required this.text,
    required this.isSelected,
    required this.onToggleSelection,
    required this.spin,
    required this.iconPath,
    this.isDisabled = false,
  });
  final String text;
  final bool isSelected;
  final ValueChanged<SpinType> onToggleSelection;
  final SpinType spin;
  final String iconPath;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isSelected || isDisabled
          ? GreenButton(
              text: text,
              isDisabled: isDisabled,
              onPressed: () {
                onToggleSelection(spin);
              },
              hasShadow: false,
              mode: .selection,
              iconPath: iconPath,
            )
          : WhiteButton(
              text: text,
              isDisabled: isDisabled,
              onPressed: () {
                onToggleSelection(spin);
              },
              hasShadow: false,
              mode: .selection,
              iconPath: iconPath,
            ),
    );
  }
}
