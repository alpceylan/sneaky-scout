import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
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
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: deviceWidth * 200,
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
