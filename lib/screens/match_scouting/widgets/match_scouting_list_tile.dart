import 'package:flutter/material.dart';

// Services
import '../../../services/match_scouting_service.dart';

// Screens
import '../../match_scouting_detail/match_scouting_detail_screen.dart';

// Models
import '../../../models/match_scouting_team.dart';

// Widgets
import '../../../widgets/dismissible_alert.dart';
import '../../../widgets/dismissible_background.dart';

// Enums
import '../../../enums/match_scouting_enums.dart';

class MatchScoutingListTile extends StatelessWidget {
  final List<MatchScoutingTeam> teamList;
  final MatchScoutingTeam team;
  final int index;

  MatchScoutingListTile({
    this.teamList,
    this.team,
    this.index,
  });

  final MatchScoutingService _matchScoutingService = MatchScoutingService();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          MatchScoutingDetailScreen.routeName,
          arguments: team,
        );
      },
      child: Dismissible(
        key: Key("$index"),
        onDismissed: (direction) async {
          await _matchScoutingService.deleteTeam(
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
