import 'package:flutter/material.dart';

// Services
import '../../services/online_match_scouting_service.dart';
import '../../services/match_scouting_service.dart';
import '../../services/online_pit_scouting_service.dart';
import '../../services/pit_scouting_service.dart';
import '../../services/google_sheets_service.dart';

// Screens
import '../match_scouting/match_scouting_screen.dart';
import '../pit_scouting/pit_scouting_screen.dart';
import '../team_scouts/team_scouts_screen.dart';
import '../match_scouting_detail/match_scouting_detail_screen.dart';
import '../pit_scouting_detail/pit_scouting_detail_screen.dart';

// Models
import '../../models/match_scouting_team.dart';
import '../../models/pit_scouting_team.dart';

// Widgets
import './widgets/custom_drawer.dart';
import './widgets/custom_bottom_navigation_bar.dart';

// Enums
import '../../enums/match_scouting_enums.dart';
import '../../enums/pit_scouting_enums.dart' as ps;

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
  GoogleSheetsService _sheetsService = GoogleSheetsService();

  int currentIndex = 0;

  void _addNewTeam() {
    if (currentIndex == 0) {
      var team = MatchScoutingTeam();

      Navigator.of(context).pushNamed(
        MatchScoutingDetailScreen.routeName,
        arguments: team,
      );
    } else if (currentIndex == 1) {
      var team = PitScoutingTeam();

      Navigator.of(context).pushNamed(
        PitScoutingDetailScreen.routeName,
        arguments: team,
      );
    }
  }

  String get floatingActionButtonLabel {
    switch (currentIndex) {
      case 0:
        return "Add new match";
      case 1:
        return "Add new pit";
      default:
        return "";
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
              List<MatchScoutingTeam> unsyncedTeams = [];

              teams.forEach((team) {
                if (team.status != Status.Synced) {
                  unsyncedTeams.add(team);
                }
              });
              unsyncedTeams.forEach((team) async {
                await _onlineMatchScoutingService.saveTeam(team);
              });
              await _sheetsService.syncMatchScouts(unsyncedTeams);
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
              List<PitScoutingTeam> teams =
                  await _pitScoutingService.getTeams();
              teams.forEach((team) async {
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
                floatingActionButtonLabel,
              ),
            )
          : null,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
