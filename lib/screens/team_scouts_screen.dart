import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

// Services
import '../services/match_scouting_service.dart';
import '../services/online_match_scouting_service.dart';
import '../services/pit_scouting_service.dart';
import '../services/online_pit_scouting_service.dart';

// Screens
import './pit_scouting_detail_screen.dart';
import './match_scouting_detail_screen.dart';

// Models
import '../models/pit_scouting_team.dart';
import '../models/match_scouting_team.dart' as ms;

class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  MatchScoutingService _matchScoutingService = MatchScoutingService();
  OnlineMatchScoutingService _onlineMatchScoutingService =
      OnlineMatchScoutingService();
  PitScoutingService _pitScoutingService = PitScoutingService();
  OnlinePitScoutingService _onlinePitScoutingService =
      OnlinePitScoutingService();

  int _currentSelection = 0;

  List<ms.MatchScoutingTeam> matchScoutingTeamList = [];
  List<PitScoutingTeam> pitScoutingTeamList = [];

  Future<void> getTeams() async {
    matchScoutingTeamList = [];
    pitScoutingTeamList = [];

    // Match Scouting
    List<Map<String, dynamic>> matchScouts =
        await _matchScoutingService.getTeams();
    matchScouts.forEach((teamMap) {
      var team = ms.MatchScoutingTeam().unmapTeam(teamMap, false);
      matchScoutingTeamList.add(team);
    });
    List<ms.MatchScoutingTeam> onlineMatchScouts =
        await _onlineMatchScoutingService.getTeams();
    onlineMatchScouts.forEach((newTeam) {
      var teamExist = matchScoutingTeamList.firstWhere(
        (team) => team.id == newTeam.id,
        orElse: () => null,
      );
      if (teamExist == null) {
        matchScoutingTeamList.add(newTeam);
      }
    });

    // Pit Scouting
    List<Map<String, dynamic>> pitScouts = await _pitScoutingService.getTeams();
    pitScouts.forEach((teamMap) {
      var team = PitScoutingTeam().unmapTeam(teamMap, false);
      pitScoutingTeamList.add(team);
    });
    List<PitScoutingTeam> onlinePitScouts =
        await _onlinePitScoutingService.getTeams();
    onlinePitScouts.forEach((newTeam) {
      var teamExist = pitScoutingTeamList.firstWhere(
        (team) => team.id == newTeam.id,
        orElse: () => null,
      );
      if (teamExist == null) {
        pitScoutingTeamList.add(newTeam);
      }
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

    Widget _createMatchScoutingListTile(ms.MatchScoutingTeam team) {
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
                team.status == ms.Status.Synced ? "Synced" : "Unsynced",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: deviceWidth * 0.03,
              ),
              CircleAvatar(
                backgroundColor:
                    team.status == ms.Status.Synced ? Colors.green : Colors.red,
                child: Icon(
                  team.status == ms.Status.Synced ? Icons.done : Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _createPitScoutingListTile(PitScoutingTeam team) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            PitScoutingDetailScreen.routeName,
            arguments: team,
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: MemoryImage(
              base64Decode(team.imageString),
            ),
          ),
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
      0: Text('      Match Scouting      '),
      1: Text('      Pit Scouting       '),
    };

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              ? matchScoutingTeamList.length == 0
                  ? Container(
                      height: deviceHeight * 0.6,
                      alignment: Alignment.center,
                      child: Text("There are no match scouting teams."),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return _createMatchScoutingListTile(
                          matchScoutingTeamList[i],
                        );
                      },
                      itemCount: matchScoutingTeamList.length,
                    )
              : pitScoutingTeamList.length == 0
                  ? Container(
                      height: deviceHeight * 0.6,
                      alignment: Alignment.center,
                      child: Text("There are no pit scouting teams."),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return _createPitScoutingListTile(
                          pitScoutingTeamList[i],
                        );
                      },
                      itemCount: pitScoutingTeamList.length,
                    ),
        ],
      ),
    );
  }
}
