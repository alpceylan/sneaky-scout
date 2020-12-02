import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

// Services
import '../services/match_scouting_service.dart';

// Screens
import './match_scouting_detail_screen.dart';

// Models
import '../models/match_scouting_team.dart';

class MatchScoutingScreen extends StatefulWidget {
  @override
  _MatchScoutingScreenState createState() => _MatchScoutingScreenState();
}

class _MatchScoutingScreenState extends State<MatchScoutingScreen> {
  MatchScoutingService matchScoutingService = MatchScoutingService();

  int _currentSelection = 0;
  List<MatchScoutingTeam> newTeamList = [
    MatchScoutingTeam(
      scoutName: "alp",
      teamName: "Sneaky Snakes",
      teamNo: 7200,
      matchType: Match.Practice,
      matchNo: "46",
      color: "orange",
      powerCellCount: 15,
      autonomous: true,
      imageProcessing: false,
      autonomousStartingPoint: AutonomousStartingPoint.Left,
      powerCellLocation: PowerCellLocation.Inner,
      defense: true,
      finalScore: 17,
      defenseComment: "fake",
      foul: 2,
      techFoul: 13,
      comment: "very good data",
    ),
    MatchScoutingTeam(
      scoutName: "ceylan",
      teamName: "Sneaky Tigers",
      teamNo: 1532,
      matchType: Match.Qual,
      matchNo: "23",
      color: "blue",
      powerCellCount: 7,
      autonomous: true,
      imageProcessing: true,
      autonomousStartingPoint: AutonomousStartingPoint.Middle,
      powerCellLocation: PowerCellLocation.Inner,
      defense: false,
      finalScore: 13,
      defenseComment: "so good data",
      foul: 2,
      techFoul: 14,
      comment: "very very good data",
    ),
  ];
  List<MatchScoutingTeam> teamList = [];

  var isLoading = false;

  Future getTeams() async {
    setState(() {
      isLoading = true;
    });
    var teams = await matchScoutingService.getTeams();
    teamList = [];
    teams.forEach((teamMap) {
      var team = MatchScoutingTeam().unmapTeam(teamMap, false);
      teamList.add(team);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    Widget _createMatchScoutingListTile(MatchScoutingTeam team, bool isNew) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            MatchScoutingDetailScreen.routeName,
            arguments: team,
          );
        },
        child: ListTile(
          title: Text(team.scoutName),
          subtitle: Text("${team.teamNo} - ${team.teamName}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                !isNew
                    ? team.status == Status.Synced
                        ? "Synced"
                        : "Unsynced"
                    : "New",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: deviceWidth * 0.03,
              ),
              CircleAvatar(
                backgroundColor: !isNew
                    ? team.status == Status.Synced
                        ? Colors.green
                        : Colors.red
                    : Colors.blue[800],
                child: Icon(
                  !isNew
                      ? team.status == Status.Synced
                          ? Icons.done
                          : Icons.close
                      : Icons.new_releases,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Map<int, Widget> _children = {
      0: Text('      New      '),
      1: Text('      Saved       '),
    };

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () async {
              await getTeams();
            },
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: deviceHeight * 0.02,
                  ),
                  MaterialSegmentedControl(
                    children: _children,
                    selectionIndex: _currentSelection,
                    borderColor: Colors.grey,
                    selectedColor: Colors.blue,
                    unselectedColor: Colors.white,
                    borderRadius: 8.0,
                    onSegmentChosen: (index) {
                      setState(() {
                        _currentSelection = index;
                      });
                    },
                  ),
                  _currentSelection == 1
                      ? teamList.length == 0
                          ? Container(
                              height: deviceHeight * 0.6,
                              alignment: Alignment.center,
                              child: Text("There are no saved teams."),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (ctx, i) {
                                return _createMatchScoutingListTile(
                                    teamList[i], false);
                              },
                              itemCount: teamList.length,
                            )
                      : newTeamList.length == 0
                          ? Container(
                              height: deviceHeight * 0.6,
                              alignment: Alignment.center,
                              child: Text("There are no new teams."),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (ctx, i) {
                                return _createMatchScoutingListTile(
                                    newTeamList[i], true);
                              },
                              itemCount: newTeamList.length,
                            ),
                ],
              ),
            ),
          );
  }
}
