import 'package:flutter/material.dart';

// Models
import '../models/matchScoutingTeam.dart';

class MatchScoutingDetailScreen extends StatefulWidget {
  static const routeName = '/match-scouting-detail';

  @override
  _MatchScoutingDetailScreenState createState() =>
      _MatchScoutingDetailScreenState();
}

class _MatchScoutingDetailScreenState extends State<MatchScoutingDetailScreen> {
  int matchInt;
  bool autonomous;
  bool imageProcessing;
  int autonomousStartingPointInt;

  @override
  Widget build(BuildContext context) {
    final MatchScoutingTeam team =
        ModalRoute.of(context).settings.arguments as MatchScoutingTeam;

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    if (matchInt == null) {
      if (team.matchType == Match.Practice) {
        matchInt = 1;
      } else if (team.matchType == Match.Playoff) {
        matchInt = 2;
      } else {
        matchInt = 3;
      }
    }

    if (autonomous == null) autonomous = team.autonomous;

    if (imageProcessing == null) imageProcessing = team.imageProcessing;

    if (autonomousStartingPointInt == null) {
      if (team.autonomousStartingPoint == AutonomousStartingPoint.Left) {
        autonomousStartingPointInt = 1;
      } else if (team.autonomousStartingPoint ==
          AutonomousStartingPoint.Middle) {
        autonomousStartingPointInt = 2;
      } else {
        autonomousStartingPointInt = 3;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${team.teamName}"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.05,
          vertical: deviceHeight * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: deviceWidth * 0.55,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Scout Name"),
                    initialValue: team.scoutName,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: deviceWidth * 0.4,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Team Name"),
                    initialValue: team.teamName,
                  ),
                ),
                Container(
                  width: deviceWidth * 0.4,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Team Number"),
                    initialValue: "${team.teamNo}",
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: deviceWidth * 0.3,
                  height: deviceHeight * 0.065,
                  child: DropdownButton(
                    isExpanded: true,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    value: matchInt,
                    items: [
                      DropdownMenuItem(
                        child: Text("Practice"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("Playoff"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text("Qual"),
                        value: 3,
                      ),
                    ],
                    onChanged: (value) {
                      matchInt = value;
                    },
                  ),
                ),
                Container(
                  width: deviceWidth * 0.4,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Match Number"),
                    initialValue: "${team.matchNo}",
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: deviceWidth * 0.4,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Robot Color"),
                    initialValue: "${team.color}",
                  ),
                ),
                Container(
                  width: deviceWidth * 0.4,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Powercell Count"),
                    initialValue: "${team.powerCellCount}",
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Autonomous:"),
                    Switch(
                      value: autonomous,
                      activeTrackColor: Colors.lightBlueAccent,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          autonomous = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Image Processing:"),
                    Switch(
                      value: imageProcessing,
                      activeTrackColor: Colors.lightBlueAccent,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          imageProcessing = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Autonomous Starting Point:"),
                Container(
                  width: deviceWidth * 0.3,
                  height: deviceHeight * 0.065,
                  child: DropdownButton(
                    isExpanded: true,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    value: autonomousStartingPointInt,
                    items: [
                      DropdownMenuItem(
                        child: Text("Left"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("Middle"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text("Right"),
                        value: 3,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        autonomousStartingPointInt = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
