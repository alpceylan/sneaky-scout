import 'package:flutter/material.dart';

// Services
import 'package:sneakyscout/services/pit_scouting_service.dart';

// Models
import 'package:sneakyscout/models/pit_scouting_team.dart';

// Widgets
import 'package:sneakyscout/screens/pit_scouting/widgets/pit_scouting_list_tile.dart';

class PitScoutingScreen extends StatefulWidget {
  @override
  _PitScoutingScreenState createState() => _PitScoutingScreenState();
}

class _PitScoutingScreenState extends State<PitScoutingScreen> {
  PitScoutingService pitScoutingService = PitScoutingService();

  var isLoading = false;

  List<PitScoutingTeam> teamList = [];

  Future getTeams() async {
    setState(() {
      isLoading = true;
    });
    teamList = await pitScoutingService.getTeams();
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
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          )
        : SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async {
                await getTeams();
              },
              child: Container(
                color: Theme.of(context).backgroundColor,
                height: MediaQuery.of(context).size.height * 0.81,
                child: Column(
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    teamList.length == 0
                        ? Container(
                            height: deviceHeight * 0.6,
                            alignment: Alignment.center,
                            child: Text(
                              "There are no saved teams.",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (ctx, i) {
                              return PitScoutingListTile(
                                teamList: teamList,
                                team: teamList[i],
                                index: i,
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
