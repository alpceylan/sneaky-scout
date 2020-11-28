import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

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
  int _currentSelection = 0;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    List<ms.MatchScoutingTeam> matchScoutingTeamList = [];
    List<PitScoutingTeam> pitScoutingTeamList = [];

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
              ? ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    return _createMatchScoutingListTile(
                      matchScoutingTeamList[i],
                    );
                  },
                  itemCount: matchScoutingTeamList.length,
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
