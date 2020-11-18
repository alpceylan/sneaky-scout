import 'package:flutter/material.dart';

// Models
import '../models/matchScoutingTeam.dart';

class MatchScoutingDetailScreen extends StatelessWidget {
  static const routeName = '/match-scouting-detail';

  @override
  Widget build(BuildContext context) {
    final MatchScoutingTeam team =
        ModalRoute.of(context).settings.arguments as MatchScoutingTeam;

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("${team.teamNo}"),
      ),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          children: [
            Row(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Scout Name"),
                  initialValue: team.scoutName,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
