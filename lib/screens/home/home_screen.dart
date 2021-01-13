import 'package:flutter/material.dart';

// Services
import 'package:sneakyscout/services/google_sheets_service.dart';
import 'package:sneakyscout/services/match_scouting_service.dart';
import 'package:sneakyscout/services/online_match_scouting_service.dart';
import 'package:sneakyscout/services/online_pit_scouting_service.dart';
import 'package:sneakyscout/services/pit_scouting_service.dart';

// Screens
import 'package:sneakyscout/screens/match_scouting/match_scouting_screen.dart';
import 'package:sneakyscout/screens/match_scouting_detail/match_scouting_detail_screen.dart';
import 'package:sneakyscout/screens/pit_scouting/pit_scouting_screen.dart';
import 'package:sneakyscout/screens/pit_scouting_detail/pit_scouting_detail_screen.dart';
import 'package:sneakyscout/screens/team_scouts/team_scouts_screen.dart';

// Models
import 'package:sneakyscout/models/match_scouting_team.dart';
import 'package:sneakyscout/models/pit_scouting_team.dart';

// Widgets
import 'package:sneakyscout/screens/home/widgets/custom_bottom_navigation_bar.dart';
import 'package:sneakyscout/screens/home/widgets/custom_drawer.dart';

// Enums
import 'package:sneakyscout/enums/match_scouting_enums.dart';
import 'package:sneakyscout/enums/pit_scouting_enums.dart' as ps;

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
  bool firstTime = true;

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
    final index = ModalRoute.of(context).settings.arguments;
    if (index != null) if (firstTime) currentIndex = index as int;

    List<Widget> appBars = [
      AppBar(
        title: Text(
          "Match Scouting",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
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
        title: Text(
          "Pit Scouting",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
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
        title: Text(
          "Team Scouts",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
    ];

    List<Widget> screens = [
      MatchScoutingScreen(),
      PitScoutingScreen(),
      TeamScreen(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBars[currentIndex],
      body: screens[currentIndex],
      drawer: CustomDrawer(),
      floatingActionButton: currentIndex == 0 || currentIndex == 1
          ? FloatingActionButton.extended(
              backgroundColor: Theme.of(context).buttonColor,
              onPressed: _addNewTeam,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).hintColor,
              ),
              label: Text(
                floatingActionButtonLabel,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            )
          : null,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            firstTime = false;
          });
        },
      ),
    );
  }
}
