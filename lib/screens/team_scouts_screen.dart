import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

// Services
import '../services/match_scouting_service.dart';
import '../services/online_match_scouting_service.dart';
import '../services/pit_scouting_service.dart';
import '../services/online_pit_scouting_service.dart';
import '../services/authentication_service.dart';

// Screens
import './pit_scouting_detail_screen.dart';
import './match_scouting_detail_screen.dart';

// Models
import '../models/pit_scouting_team.dart';
import '../models/match_scouting_team.dart' as ms;
import '../models/custom_user.dart';

class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  MatchScoutingService _matchScoutingService = MatchScoutingService();
  OnlineMatchScoutingService _onlineMatchScoutingService =
      OnlineMatchScoutingService();
  PitScoutingService _pitScoutingService = PitScoutingService();
  OnlinePitScoutingService _onlinePitScoutingService =
      OnlinePitScoutingService();
  AuthenticationService _authService = AuthenticationService();

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
    List<ms.MatchScoutingTeam> msTeamList =
        await _matchScoutingService.getTeams();
    msTeamList.forEach((team) {
      if (team.status == ms.Status.Synced) {
        matchScoutingTeamList.add(team);
      }
    });
    List<ms.MatchScoutingTeam> onlineMatchScouts =
        await _onlineMatchScoutingService.getTeams();
    onlineMatchScouts.forEach((newTeam) {
      var teamExist = matchScoutingTeamList.firstWhere(
        (team) => team.id == newTeam.id,
        orElse: () => null,
      );
      if (teamExist == null) {
        matchScoutingTeamList.add(newTeam);
      }
    });

    // Pit Scouting
    List<PitScoutingTeam> psTeamList = await _pitScoutingService.getTeams();
    psTeamList.forEach((team) {
      if (team.status == Status.Synced) {
        pitScoutingTeamList.add(team);
      }
    });
    List<PitScoutingTeam> onlinePitScouts =
        await _onlinePitScoutingService.getTeams();
    onlinePitScouts.forEach((newTeam) {
      if (pitScoutingTeamList.length > 0) {
        var teamExist = pitScoutingTeamList.firstWhere(
          (team) => team.teamNo == newTeam.teamNo,
          orElse: () => null,
        );
        if (teamExist == null) {
          pitScoutingTeamList.add(newTeam);
        }
      } else {
        pitScoutingTeamList.add(newTeam);
      }
    });

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

    Widget _createMatchScoutingListTile(ms.MatchScoutingTeam team) {
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
        child: ListTile(
          title: Text(team.scoutName),
          subtitle: Text("${team.teamNo} - ${team.teamName}"),
          trailing: user.userId == _authService.currentUser.uid
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      team.status == ms.Status.Synced ? "Synced" : "Unsynced",
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
      );
    }

    Widget _createPitScoutingListTile(PitScoutingTeam team) {
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
                        team.status == Status.Synced ? Icons.done : Icons.close,
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
