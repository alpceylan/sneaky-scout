import 'package:flutter/material.dart';

// Services
import 'package:sneakyscout/services/authentication_service.dart';
import 'package:sneakyscout/services/google_sheets_service.dart';
import 'package:sneakyscout/services/match_scouting_service.dart';
import 'package:sneakyscout/services/online_match_scouting_service.dart';

// Screens
import 'package:sneakyscout/screens/match_scouting_detail/match_scouting_detail_screen.dart';

// Models
import 'package:sneakyscout/models/custom_user.dart';
import 'package:sneakyscout/models/match_scouting_team.dart';

// Widgets
import 'package:sneakyscout/widgets/dismissible_alert.dart';
import 'package:sneakyscout/widgets/dismissible_background.dart';

// Enums
import 'package:sneakyscout/enums/match_scouting_enums.dart';

class MatchScoutingListTile extends StatelessWidget {
  final List<MatchScoutingTeam> matchScoutingTeamList;
  final MatchScoutingTeam team;
  final List<CustomUser> userList;
  final int index;

  MatchScoutingListTile({
    this.matchScoutingTeamList,
    this.team,
    this.userList,
    this.index,
  });

  final AuthenticationService _authService = AuthenticationService();
  final MatchScoutingService _matchScoutingService = MatchScoutingService();
  final OnlineMatchScoutingService _onlineMatchScoutingService =
      OnlineMatchScoutingService();
  final GoogleSheetsService _sheetsService = GoogleSheetsService();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    CustomUser user = userList.firstWhere(
      (user) => user.userId == team.userId,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          MatchScoutingDetailScreen.routeName,
          arguments: team,
        );
      },
      child: AbsorbPointer(
        absorbing: user.userId != _authService.currentUser.uid,
        child: Dismissible(
          key: Key("$index"),
          onDismissed: (direction) async {
            await _onlineMatchScoutingService.deleteTeam(
              matchScoutingTeamList[index],
            );
            await _sheetsService.deleteScoutIfExists(team);
            var newTeam = team.changeStatus(Status.Unsynced);
            await _matchScoutingService.updateTeam(newTeam);

            matchScoutingTeamList.removeAt(index);
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
            title: Text(
              team.scoutName,
              style: TextStyle(
                color: Theme.of(context).textSelectionColor,
              ),
            ),
            subtitle: Text(
              "${team.teamNo} - ${team.teamName}",
              style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
              ),
            ),
            trailing: user.userId == _authService.currentUser.uid
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        team.status == Status.Synced ? "Synced" : "Unsynced",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textSelectionColor,
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.03,
                      ),
                      CircleAvatar(
                        backgroundColor: team.status == Status.Synced
                            ? Colors.green
                            : Colors.red,
                        child: Icon(
                          team.status == Status.Synced
                              ? Icons.done
                              : Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "${user.teamNumber}",
                            style: TextStyle(
                              color: Theme.of(context).textSelectionHandleColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: deviceWidth * 0.025,
                      ),
                      CircleAvatar(
                        backgroundImage: user.photoUrl != null
                            ? NetworkImage(
                                user.photoUrl,
                              )
                            : AssetImage(
                                "assets/images/default_profile_photo.png",
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
