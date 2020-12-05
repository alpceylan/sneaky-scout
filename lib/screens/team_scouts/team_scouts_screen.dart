import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

// Services
import '../../services/online_match_scouting_service.dart';
import '../../services/online_pit_scouting_service.dart';
import '../../services/authentication_service.dart';

// Models
import '../../models/pit_scouting_team.dart';
import '../../models/match_scouting_team.dart' as ms;
import '../../models/custom_user.dart';

// Widgets
import './widgets/match_scouting_list_tile.dart';
import './widgets/pit_scouting_list_tile.dart';

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
                                  return MatchScoutingListTile(
                                    matchScoutingTeamList:
                                        matchScoutingTeamList,
                                    team: matchScoutingTeamList[i],
                                    userList: userList,
                                    index: i,
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
                                  return PitScoutingListTile(
                                    pitScoutingTeamList: pitScoutingTeamList,
                                    team: pitScoutingTeamList[i],
                                    userList: userList,
                                    index: i,
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
