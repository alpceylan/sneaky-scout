import 'package:flutter/material.dart';

// Screens
import './match_scouting_screen.dart';
import './pit_scouting_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> appBars = [
      AppBar(
        title: Text("Match Scouting"),
        actions: [
          !MatchScoutingScreen().teamMode
              ? IconButton(
                  icon: Icon(Icons.sync),
                  onPressed: () {
                    print("sync button clicked.");
                  },
                )
              : null
        ],
      ),
      AppBar(
        title: Text("Pit"),
        actions: [
          !PitScoutingScreen().teamMode
              ? IconButton(
                  icon: Icon(Icons.sync),
                  onPressed: () {
                    print("sync button clicked.");
                  },
                )
              : null
        ],
      ),
      AppBar(
        title: Text("Team"),
      ),
      AppBar(
        title: Text("Profile"),
      ),
    ];

    List<Widget> screens = [
      MatchScoutingScreen(),
      PitScoutingScreen(),
      Center(child: Text("Profile")),
    ];

    return Scaffold(
      appBar: appBars[currentIndex],
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
              Icons.person,
            ),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
