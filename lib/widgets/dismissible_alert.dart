import 'package:flutter/material.dart';

class DismissibleAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you wish to delete this item?"),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            "DELETE",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("CANCEL"),
        ),
      ],
    );
  }
}
