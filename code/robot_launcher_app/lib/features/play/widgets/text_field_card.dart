import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/widgets/card.dart';
import 'package:robot_launcher_app/shared/widgets/robot_text_field.dart';
import 'package:robot_launcher_app/shared/widgets/texts.dart';

class TextFieldCard extends StatefulWidget {
  const TextFieldCard({super.key});
  @override
  State<StatefulWidget> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldCard> {
  late FocusNode _focusNode;
  late FocusNode _buttonFocusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _buttonFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: .start,
        children: [
          TitleText('Name:'),
          Row(
            children: [
              Expanded(
                child: RobotTextField(
                  onSubmitted: (_) => setState(() {}),

                  defaultInput: "Scen_00",
                  focusNode: _focusNode,
                  onTap: () => setState(() => _buttonFocusNode.requestFocus()),
                ),
              ),
              if (!_focusNode.hasFocus)
                IconButton(
                  focusNode: _buttonFocusNode,
                  onPressed: () {
                    setState(() {
                      _focusNode.requestFocus();
                    });
                  },
                  iconSize: _buttonFocusNode.hasFocus ? 25 : 20,
                  icon: Icon(Icons.edit),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
