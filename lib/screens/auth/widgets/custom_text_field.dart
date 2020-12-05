import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Icon icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String) onSaved;
  final Function(String) validator;

  CustomTextField({
    this.labelText,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.name,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: deviceWidth * 0.01,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
