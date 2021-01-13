import 'package:flutter/material.dart';

//ignore: must_be_immutable
class CommentBox extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final Function(String) onSaved;
  final int maxLines;
  final bool isCurrentUser;
  final bool visible;

  CommentBox({
    this.labelText,
    this.initialValue,
    this.onSaved,
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
        labelStyle: TextStyle(
          color: Theme.of(context).textSelectionColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).canvasColor,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).canvasColor,
          ),
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      enabled: isCurrentUser,
      validator: (value) {
        if (visible) {
          if (value.length == 0) {
            return "$labelText shouldn't be empty.";
          }
          return null;
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
