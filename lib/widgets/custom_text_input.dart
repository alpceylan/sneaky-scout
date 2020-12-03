import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final double deviceWidth;
  final String labelText;
  final String initialValue;
  final TextInputType keyboardType;
  final bool enabled;
  final Function(String value) validator;
  final Function(String newValue) onSaved;

  CustomTextInput({
    @required this.deviceWidth,
    @required this.labelText,
    this.initialValue,
    this.keyboardType,
    this.enabled,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth * 0.4,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
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
