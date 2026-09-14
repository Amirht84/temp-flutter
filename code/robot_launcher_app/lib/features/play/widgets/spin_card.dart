import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/assets.dart';
import 'package:robot_launcher_app/shared/widgets/buttons.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:robot_launcher_app/shared/widgets/dividers.dart';
import 'package:robot_launcher_app/shared/widgets/texts.dart';

class SpinCard extends StatefulWidget {
  const SpinCard({
    super.key,
    this.isDisabled = false
  });
  final bool isDisabled;
  @override
  State<StatefulWidget> createState() => _SpinCardState();
}
class _SpinCardState extends State<SpinCard> {
  int? selectedId;
  void _onToggle(id) {
    setState(() {
      if(selectedId == id) {
        selectedId = null;
      } else {
        selectedId = id;
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
              _SelectionButton(text: "Flat", isSelected: selectedId == 0, onToggleSelection: _onToggle, id: 0, iconPath: AppAssets.flat, isDisabled: widget.isDisabled,),
              EmptyDivider(isVertical: true,),
              _SelectionButton(text: "TopSpin", isSelected: selectedId == 1, onToggleSelection: _onToggle, id: 1, iconPath: AppAssets.topSpin, isDisabled: widget.isDisabled),
              EmptyDivider(isVertical: true),
              _SelectionButton(text: "Slice", isSelected: selectedId == 2, onToggleSelection: _onToggle, id: 2, iconPath: AppAssets.slice, isDisabled: widget.isDisabled),
              EmptyDivider(isVertical: true),
              _SelectionButton(text: "Kick", isSelected: selectedId == 3, onToggleSelection: _onToggle, id: 3, iconPath: AppAssets.kick, isDisabled: widget.isDisabled,),
            ],
          )
        ]
      )
    );
  }
}

class _SelectionButton extends StatelessWidget {
  const _SelectionButton({
    required this.text,
    required this.isSelected,
    required this.onToggleSelection,
    required this.id,
    required this.iconPath,
    this.isDisabled = false,
  });
  final String text;
  final bool isSelected;
  final ValueChanged<int> onToggleSelection;
  final int id;
  final String iconPath;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isSelected || isDisabled
        ? GreenButton(text: text, isDisabled: isDisabled ,onPressed: (){onToggleSelection(id);}, hasShadow: false, mode: .selection, iconPath: iconPath,)
        : WhiteButton(text: text, isDisabled: isDisabled ,onPressed: (){onToggleSelection(id);}, hasShadow: false, mode: .selection, iconPath: iconPath,)
    );
  }
}