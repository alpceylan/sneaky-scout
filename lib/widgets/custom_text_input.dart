import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final TextInputType keyboardType;
  final bool enabled;
  final Function(String value) validator;
  final Function(String newValue) onSaved;

  CustomTextInput({
    @required this.labelText,
    this.initialValue,
    this.keyboardType,
    this.enabled,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: deviceWidth * 0.4,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).textSelectionColor,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).highlightColor,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).highlightColor,
            ),
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        initialValue: initialValue,
        keyboardType: keyboardType,
        enabled: enabled,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
