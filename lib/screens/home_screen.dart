import 'package:flutter/material.dart';

// Screens
import './match_scouting_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  var teamMode = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> appBars = [
      AppBar(
        title: Text("Match Scouting"),
        actions: [
          !teamMode
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
      Center(child: Text("Pit")),
      Center(child: Text("Team")),
      Center(child: Text("Profile")),
    ];

    return Scaffold(
      appBar: appBars[currentIndex],
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_on),
            label: "Match Scouting",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browser_not_supported_outlined),
            label: "Pit Scouting",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
