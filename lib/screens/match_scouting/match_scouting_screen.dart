import 'package:flutter/material.dart';

// Services
import 'package:sneakyscout/services/match_scouting_service.dart';

// Models
import 'package:sneakyscout/models/match_scouting_team.dart';

// Widgets
import 'package:sneakyscout/screens/match_scouting/widgets/match_scouting_list_tile.dart';

class MatchScoutingScreen extends StatefulWidget {
  @override
  _MatchScoutingScreenState createState() => _MatchScoutingScreenState();
}

class _MatchScoutingScreenState extends State<MatchScoutingScreen> {
  MatchScoutingService matchScoutingService = MatchScoutingService();

  List<MatchScoutingTeam> teamList = [];

  var isLoading = false;

  Future getTeams() async {
    setState(() {
      isLoading = true;
    });
    teamList = await matchScoutingService.getTeams();
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
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    teamList.length == 0
                        ? Container(
                            height: deviceHeight * 0.6,
                            alignment: Alignment.center,
                            child: Text("There are no saved teams."),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (ctx, i) {
                              return MatchScoutingListTile(
                                team: teamList[i],
                                index: i,
                                teamList: teamList,
                              );
                            },
                            itemCount: teamList.length,
                          ),
                  ],
                ),
              ),
            ),
          );
  }
}
