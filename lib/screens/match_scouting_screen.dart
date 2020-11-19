import 'package:flutter/material.dart';

// Screens
import './match_scouting_detail_screen.dart';

// Models
import '../models/matchScoutingTeam.dart';

class MatchScoutingScreen extends StatelessWidget {
  var teamMode = false;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    final List<MatchScoutingTeam> mstList = [
      MatchScoutingTeam(
          scoutName: "my first scout",
          teamName: "turkish frc team",
          teamNo: 7285,
          matchType: Match.Practice,
          matchNo: 03,
          color: "orange",
          powerCellCount: 3,
          powerCellLocation: PowerCellLocation.Inner,
          autonomous: true,
          autonomousStartingPoint: AutonomousStartingPoint.Middle,
          defense: true,
          defenseComment: "it was fantastic!",
          foul: 3,
          techFoul: 4,
          imageProcessing: true,
          finalScore: 11,
          comment: "lets follow this team"),
      MatchScoutingTeam(
          status: Status.Synced,
          scoutName: "my second scout",
          teamName: "polish frc team",
          teamNo: 7490,
          matchType: Match.Qual,
          matchNo: 10,
          color: "red",
          powerCellCount: 5,
          powerCellLocation: PowerCellLocation.Inner,
          autonomous: true,
          autonomousStartingPoint: AutonomousStartingPoint.Left,
          defense: true,
          defenseComment: "it was fantastic!",
          foul: 3,
          techFoul: 4,
          imageProcessing: true,
          finalScore: 11,
          comment: "lets follow this team"),
      MatchScoutingTeam(
          scoutName: "my third scout",
          teamName: "lebanese frc team",
          teamNo: 7490,
          matchType: Match.Qual,
          matchNo: 15,
          color: "blue",
          powerCellCount: 2,
          powerCellLocation: PowerCellLocation.Inner,
          autonomous: true,
          autonomousStartingPoint: AutonomousStartingPoint.Middle,
          defense: true,
          defenseComment: "it was great!",
          foul: 3,
          techFoul: 4,
          imageProcessing: true,
          finalScore: 15,
          comment: "lets follow this team"),
    ]; // fake data

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

    return Container(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, i) {
              return _createMatchScoutingListTile(mstList[i]);
            },
            itemCount: mstList.length,
          ),
        ],
      ),
    );
  }
}
