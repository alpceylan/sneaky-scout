import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

// Services
import '../services/pit_scouting_service.dart';

// Screens
import '../screens/pit_scouting_detail_screen.dart';

// Models
import '../models/pit_scouting_team.dart';

class PitScoutingScreen extends StatefulWidget {
  var teamMode = false;

  @override
  _PitScoutingScreenState createState() => _PitScoutingScreenState();
}

class _PitScoutingScreenState extends State<PitScoutingScreen> {
  PitScoutingService pitScoutingService = PitScoutingService();

  var isLoading = false;

  int _currentSelection = 0;
  final List<PitScoutingTeam> teamList = [];

  Future getTeams() async {
    setState(() {
      isLoading = true;
    });
    var teams = await pitScoutingService.getTeams();
    teams.forEach((teamMap) {
      var team = PitScoutingTeam().unmapTeam(teamMap);
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
      0: Text('      New      '),
      1: Text('      Saved       '),
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
                _currentSelection == 1
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          return _createPitScoutingListTile(teamList[i]);
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
