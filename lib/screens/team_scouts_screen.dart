import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

// Services
import '../services/online_match_scouting_service.dart';
import '../services/online_pit_scouting_service.dart';
import '../services/authentication_service.dart';
import '../services/google_sheets_service.dart';

// Screens
import './pit_scouting_detail_screen.dart';
import './match_scouting_detail_screen.dart';

// Models
import '../models/pit_scouting_team.dart';
import '../models/match_scouting_team.dart' as ms;
import '../models/custom_user.dart';

// Widgets
import '../widgets/dismissible_background.dart';
import '../widgets/dismissible_alert.dart';

class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  OnlineMatchScoutingService _onlineMatchScoutingService =
      OnlineMatchScoutingService();
  OnlinePitScoutingService _onlinePitScoutingService =
      OnlinePitScoutingService();
  AuthenticationService _authService = AuthenticationService();
  GoogleSheetsService _sheetsService = GoogleSheetsService();

  int _currentSelection = 0;
  var isLoading = false;

  List<ms.MatchScoutingTeam> matchScoutingTeamList = [];
  List<PitScoutingTeam> pitScoutingTeamList = [];
  List<CustomUser> userList = [];

  Future<void> getTeams() async {
    setState(() {
      isLoading = true;
    });

    matchScoutingTeamList = [];
    pitScoutingTeamList = [];
    userList = [];

    // Match Scouting
    List<ms.MatchScoutingTeam> onlineMatchScouts =
        await _onlineMatchScoutingService.getTeams();
    matchScoutingTeamList = onlineMatchScouts;

    // Pit Scouting
    List<PitScoutingTeam> onlinePitScouts =
        await _onlinePitScoutingService.getTeams();
    pitScoutingTeamList = onlinePitScouts;

    // User
    userList = await _authService.getUsers();

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

    Widget _createMatchScoutingListTile(ms.MatchScoutingTeam team, int index) {
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
              title: Text(team.scoutName),
              subtitle: Text("${team.teamNo} - ${team.teamName}"),
              trailing: user.userId == _authService.currentUser.uid
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          team.status == ms.Status.Synced
                              ? "Synced"
                              : "Unsynced",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: deviceWidth * 0.03,
                        ),
                        CircleAvatar(
                          backgroundColor: team.status == ms.Status.Synced
                              ? Colors.green
                              : Colors.red,
                          child: Icon(
                            team.status == ms.Status.Synced
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

    Widget _createPitScoutingListTile(PitScoutingTeam team, int index) {
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

    Map<int, Widget> _children = {
      0: Text('      Match Scouting      '),
      1: Text('      Pit Scouting       '),
    };

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async {
                await getTeams();
              },
              child: Container(
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
                                child:
                                    Text("There are no match scouting teams."),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (ctx, i) {
                                  return _createMatchScoutingListTile(
                                    matchScoutingTeamList[i],
                                    i,
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
                                    i,
                                  );
                                },
                                itemCount: pitScoutingTeamList.length,
                              ),
                  ],
                ),
              ),
            ),
          );
  }
}
