import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.radio_button_on,
          ),
          label: "Match Scouting",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.browser_not_supported_outlined,
          ),
          label: "Pit Scouting",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group,
          ),
          label: "Team Scouts",
        ),
      ],
      onTap: onTap,
    );
  }
}
