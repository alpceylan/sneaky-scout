import 'dart:convert';

import 'package:flutter/material.dart';

// Services
import '../../../services/authentication_service.dart';
import '../../../services/pit_scouting_service.dart';
import '../../../services/online_pit_scouting_service.dart';

// Screens
import '../../pit_scouting_detail/pit_scouting_detail_screen.dart';

// Models
import '../../../models/pit_scouting_team.dart';
import '../../../models/custom_user.dart';

// Widgets
import '../../../widgets/dismissible_alert.dart';
import '../../../widgets/dismissible_background.dart';

// Enums
import '../../../enums/pit_scouting_enums.dart';

class PitScoutingListTile extends StatelessWidget {
  final List<PitScoutingTeam> pitScoutingTeamList;
  final PitScoutingTeam team;
  final List<CustomUser> userList;
  final int index;

  PitScoutingListTile({
    this.pitScoutingTeamList,
    this.team,
    this.userList,
    this.index,
  });

  final AuthenticationService _authService = AuthenticationService();
  final PitScoutingService _pitScoutingService = PitScoutingService();
  final OnlinePitScoutingService _onlinePitScoutingService =
      OnlinePitScoutingService();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    CustomUser user = userList.firstWhere(
      (user) => user.userId == team.userId,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PitScoutingDetailScreen.routeName,
          arguments: team,
        );
      },
      child: AbsorbPointer(
        absorbing: user.userId != _authService.currentUser.uid,
        child: Dismissible(
          key: Key("$index"),
          onDismissed: (direction) async {
            await _onlinePitScoutingService.deleteTeam(
              pitScoutingTeamList[index],
            );
            var newTeam = team.changeStatus(Status.Unsynced);
            await _pitScoutingService.updateTeam(newTeam);

            pitScoutingTeamList.removeAt(index);
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
            trailing: user.userId == _authService.currentUser.uid
                ? Row(
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
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "${user.teamNumber}",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 11,
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
