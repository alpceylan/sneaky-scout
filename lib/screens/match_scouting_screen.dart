import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

// Services
import '../services/match_scouting_service.dart';

// Screens
import './match_scouting_detail_screen.dart';

// Models
import '../models/match_scouting_team.dart';

class MatchScoutingScreen extends StatefulWidget {
  var teamMode = false;

  @override
  _MatchScoutingScreenState createState() => _MatchScoutingScreenState();
}

class _MatchScoutingScreenState extends State<MatchScoutingScreen> {
  MatchScoutingService matchScoutingService = MatchScoutingService();

  int _currentSelection = 0;
  List<MatchScoutingTeam> teamList = [];

  var isLoading = false;

  Future getTeams() async {
    setState(() {
      isLoading = true;
    });
    var teams = await matchScoutingService.getTeams();
    teams.forEach((teamMap) {
      Match matchType;
      PowerCellLocation powerCellLocation;
      AutonomousStartingPoint autonomousStartingPoint;

      if (teamMap["matchType"] == "practice") {
        matchType = Match.Practice;
      } else if (teamMap["matchType"] == "playoff") {
        matchType = Match.Playoff;
      } else {
        matchType = Match.Qual;
      }

      if (teamMap["powerCellLocation"] == "inner") {
        powerCellLocation = PowerCellLocation.Inner;
      } else if (teamMap["powerCellLocation"] == "lower") {
        powerCellLocation = PowerCellLocation.Lower;
      } else {
        powerCellLocation = PowerCellLocation.Outer;
      }

      if (teamMap["autonomousStartingPoint"] == "left") {
        autonomousStartingPoint = AutonomousStartingPoint.Left;
      } else if (teamMap["autonomousStartingPoint"] == "middle") {
        autonomousStartingPoint = AutonomousStartingPoint.Middle;
      } else {
        autonomousStartingPoint = AutonomousStartingPoint.Right;
      }

      var team = MatchScoutingTeam(
        status: teamMap["status"] == 'synced' ? Status.Synced : Status.Unsynced,
        scoutName: teamMap["scoutName"],
        teamName: teamMap["teamName"],
        teamNo: teamMap["teamNo"],
        matchType: matchType,
        matchNo: teamMap["matchNo"],
        color: teamMap["color"],
        powerCellCount: teamMap["powerCellCount"],
        powerCellLocation: powerCellLocation,
        autonomous: teamMap["autonomous"] == 1 ? true : false,
        autonomousStartingPoint: autonomousStartingPoint,
        comment: teamMap["comment"],
        defense: teamMap["defense"] == 1 ? true : false,
        defenseComment: teamMap["defenseComment"],
        foul: teamMap["foul"],
        techFoul: teamMap["techFoul"],
        imageProcessing: teamMap["imageProcessing"] == 1 ? true : false,
        finalScore: teamMap["finalScore"],
      );

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

    Widget _createMatchScoutingListTile(MatchScoutingTeam team) {
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
                team.status == Status.Synced ? "Synced" : "Unsynced",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: deviceWidth * 0.03,
              ),
              CircleAvatar(
                backgroundColor:
                    team.status == Status.Synced ? Colors.green : Colors.red,
                child: Icon(
                  team.status == Status.Synced ? Icons.done : Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Map<int, Widget> _children = {
      0: Text('      Local      '),
      1: Text('      Team       '),
    };

    return Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                _currentSelection == 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          return _createMatchScoutingListTile(teamList[i]);
                        },
                        itemCount: teamList.length,
                      )
                    : Center(
                        child: Text("Hi"),
                      ),
              ],
            ),
    );
  }
}
