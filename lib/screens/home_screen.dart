import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sneaky Scout"),
      ),
      body: Container(
        child: Column(
          children: [
            Text("Hello FRC!"),
          ],
        ),
      ),
    );
  }
}
