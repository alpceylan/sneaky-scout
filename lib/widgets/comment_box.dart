import 'package:flutter/material.dart';

//ignore: must_be_immutable
class CommentBox extends StatelessWidget {
  final String labelText;
  final String initialValue;
  String value;
  final int maxLines;
  final bool isCurrentUser;
  final bool visible;

  CommentBox({
    this.labelText,
    this.initialValue,
    this.value,
    this.maxLines,
    this.isCurrentUser,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      enabled: isCurrentUser,
      validator: (value) {
        if (visible) {
          if (value.length == 0) {
            return "Climbing comment shouldn't be empty.";
          }
          return null;
        }
        return null;
      },
      onSaved: (newValue) {
        value = newValue;
      },
    );
  }
}
