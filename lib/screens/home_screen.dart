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
import '../models/pit_scouting_team.dart' as ps;

// Widgets
import '../widgets/custom_drawer.dart';

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

  void _addNewTeam() {
    if (currentIndex == 0) {
      print("match");
    } else if (currentIndex == 1) {
      print("pit");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> appBars = [
      AppBar(
        title: Text("Match Scouting"),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              List<MatchScoutingTeam> teams =
                  await _matchScoutingService.getTeams();
              teams.forEach((team) async {
                if (team.status != Status.Synced) {
                  await _onlineMatchScoutingService.saveTeam(team);
                }
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
              List<ps.PitScoutingTeam> teamList =
                  await _pitScoutingService.getTeams();
              teamList.forEach((team) async {
                if (team.status != ps.Status.Synced) {
                  await _onlinePitScoutingService.saveTeam(team);
                }
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
      drawer: CustomDrawer(),
      floatingActionButton: currentIndex == 0 || currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: _addNewTeam,
              icon: Icon(
                Icons.add,
              ),
              label: Text(
                "Add new team",
              ),
            )
          : null,
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
