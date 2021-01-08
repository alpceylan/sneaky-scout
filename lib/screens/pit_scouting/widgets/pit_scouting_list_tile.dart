import 'dart:convert';

import 'package:flutter/material.dart';

// Services
import 'package:sneakyscout/services/pit_scouting_service.dart';

// Screens
import 'package:sneakyscout/screens/pit_scouting_detail/pit_scouting_detail_screen.dart';

// Models
import 'package:sneakyscout/models/pit_scouting_team.dart';

// Widgets
import 'package:sneakyscout/widgets/dismissible_alert.dart';
import 'package:sneakyscout/widgets/dismissible_background.dart';

// Enums
import 'package:sneakyscout/enums/pit_scouting_enums.dart';

class PitScoutingListTile extends StatelessWidget {
  final List<PitScoutingTeam> teamList;
  final PitScoutingTeam team;
  final int index;

  PitScoutingListTile({
    this.teamList,
    this.team,
    this.index,
  });

  final PitScoutingService _pitScoutingService = PitScoutingService();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PitScoutingDetailScreen.routeName,
          arguments: team,
        );
      },
      child: Dismissible(
        key: Key("$index"),
        onDismissed: (direction) async {
          await _pitScoutingService.deleteTeam(
            teamList[index].teamNo,
          );
          teamList.removeAt(index);
        },
        direction: DismissDirection.endToStart,
        background: DismissibleBackground(),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DismissibleAlert();
            },
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
      ),
    );
  }
}
