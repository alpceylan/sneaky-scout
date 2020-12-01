import 'package:flutter/material.dart';

// Services
import '../services/online_match_scouting_service.dart';
import '../services/match_scouting_service.dart';
import '../services/online_pit_scouting_service.dart';
import '../services/pit_scouting_service.dart';

// Screens
import './match_scouting_screen.dart';
import './pit_scouting_screen.dart';
import './team_scouts_screen.dart';

// Models
import '../models/match_scouting_team.dart';
import '../models/pit_scouting_team.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OnlineMatchScoutingService _onlineMatchScoutingService =
      OnlineMatchScoutingService();
  MatchScoutingService _matchScoutingService = MatchScoutingService();
  OnlinePitScoutingService _onlinePitScoutingService =
      OnlinePitScoutingService();
  PitScoutingService _pitScoutingService = PitScoutingService();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> appBars = [
      AppBar(
        title: Text("Match Scouting"),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              List<Map<String, dynamic>> teams =
                  await _matchScoutingService.getTeams();
              teams.forEach((teamMap) async {
                var team = MatchScoutingTeam().unmapTeam(teamMap, false);
                await _onlineMatchScoutingService.saveTeam(team);
              });
            },
          )
        ],
      ),
      AppBar(
        title: Text("Pit Scouting"),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              List<Map<String, dynamic>> teams =
                  await _pitScoutingService.getTeams();
              teams.forEach((teamMap) async {
                var team = PitScoutingTeam().unmapTeam(teamMap, false);
                await _onlinePitScoutingService.saveTeam(team);
              });
            },
          )
        ],
      ),
      AppBar(
        title: Text("Team Scouts"),
      ),
    ];

    List<Widget> screens = [
      MatchScoutingScreen(),
      PitScoutingScreen(),
      TeamScreen(),
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
              Icons.group,
            ),
            label: "Team Scouts",
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
