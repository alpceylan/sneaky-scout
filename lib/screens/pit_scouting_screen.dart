import 'dart:convert';

import 'package:flutter/material.dart';

// Services
import '../services/pit_scouting_service.dart';

// Screens
import '../screens/pit_scouting_detail_screen.dart';

// Models
import '../models/pit_scouting_team.dart';

// Widgets
import '../widgets/dismissible_background.dart';
import '../widgets/dismissible_alert.dart';

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
    final deviceWidth = MediaQuery.of(context).size.width;

    Widget _createPitScoutingListTile(
        PitScoutingTeam team, bool isNew, int index) {
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
            await pitScoutingService.deleteTeam(
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
                  !isNew
                      ? team.status == Status.Synced
                          ? "Synced"
                          : "Unsynced"
                      : "New",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
                CircleAvatar(
                  backgroundColor: !isNew
                      ? team.status == Status.Synced
                          ? Colors.green
                          : Colors.red
                      : Colors.blue[800],
                  child: Icon(
                    !isNew
                        ? team.status == Status.Synced
                            ? Icons.done
                            : Icons.close
                        : Icons.new_releases,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                              return _createPitScoutingListTile(
                                teamList[i],
                                false,
                                i,
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
