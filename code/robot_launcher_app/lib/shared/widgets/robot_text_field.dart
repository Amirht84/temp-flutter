import 'package:flutter/material.dart';
import 'package:robot_launcher_app/shared/constants/themes.dart';

const Color textFieldColor = Colors.white70;
const double textFieldFontSize = 20;
const double textFieldPadding = 7.5;

class RobotTextField extends StatefulWidget {
  const RobotTextField({
    super.key,
    required this.focusNode,
    required this.onTap,
    this.defaultInput = "",
    this.onSubmitted,
  });

  final FocusNode focusNode;
  final VoidCallback? onTap;
  final String defaultInput;
  final ValueChanged<String>? onSubmitted;
  @override
  State<StatefulWidget> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<RobotTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.defaultInput);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(blurRadius: 8, color: Palet.shadow, offset: Offset(0, 3)),
        // ],
        color: textFieldColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        onTap: () {
          if (!widget.focusNode.hasFocus) widget.onTap?.call();
        },
        focusNode: widget.focusNode,
        readOnly: !widget.focusNode.hasFocus,
        onSubmitted: (value) {
          setState(() => widget.focusNode.unfocus());
          widget.onSubmitted?.call(value);
        },
        style: TextStyle(fontWeight: .bold, fontSize: textFieldFontSize),
        controller: _controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.focusNode.hasFocus ? textFieldPadding : 0,
            vertical: textFieldPadding,
          ),
          isDense: true,
          filled: false,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.black, width: 1.25),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
