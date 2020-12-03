import 'package:flutter/material.dart';

// Services
import '../services/match_scouting_service.dart';
import '../services/blue_alliance_service.dart';
import '../services/authentication_service.dart';

// Models
import '../models/match_scouting_team.dart';

// Widgets
import '../widgets/custom_text_input.dart';

class MatchScoutingDetailScreen extends StatefulWidget {
  static const routeName = '/match-scouting-detail';

  @override
  _MatchScoutingDetailScreenState createState() =>
      _MatchScoutingDetailScreenState();
}

class _MatchScoutingDetailScreenState extends State<MatchScoutingDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final MatchScoutingService matchScoutingService = MatchScoutingService();
  final BlueAllianceService blueAllianceService = BlueAllianceService();
  final AuthenticationService authService = AuthenticationService();

  int _matchInt;
  bool _autonomous;
  bool _imageProcessing;
  int _autonomousStartingPointInt;
  bool _defense;
  int _powercellLocationInt;

  int _newMatchInt;
  bool _newAutonomous;
  bool _newImageProcessing;
  int _newAutonomousStartingPointInt;
  bool _newDefense;
  int _newPowercellLocationInt;

  String _scoutName;
  String _teamName;
  int _teamNumber;
  String _matchNumber;
  String _robotColor;
  int _powercellCount;
  int _finalScore;
  String _defenseComment;
  int _foul;
  int _techFoul;
  String _comment;

  @override
  Widget build(BuildContext context) {
    final MatchScoutingTeam team =
        ModalRoute.of(context).settings.arguments as MatchScoutingTeam;
    final bool isNew = team.id == null ? true : false;
    final bool isCurrentUser = team.scoutName == ""
        ? true
        : team.userId == authService.currentUser.uid;

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    if (_matchInt == null) {
      if (team.matchType == Match.Practice) {
        _matchInt = 1;
      } else if (team.matchType == Match.Playoff) {
        _matchInt = 2;
      } else {
        _matchInt = 3;
      }
    }

    if (_autonomous == null) _autonomous = team.autonomous;

    if (_imageProcessing == null) _imageProcessing = team.imageProcessing;

    if (_autonomousStartingPointInt == null) {
      if (team.autonomousStartingPoint == AutonomousStartingPoint.Left) {
        _autonomousStartingPointInt = 1;
      } else if (team.autonomousStartingPoint ==
          AutonomousStartingPoint.Middle) {
        _autonomousStartingPointInt = 2;
      } else {
        _autonomousStartingPointInt = 3;
      }
    }

    if (_defense == null) _defense = team.defense;

    if (_powercellLocationInt == null) {
      if (team.powerCellLocation == PowerCellLocation.Inner) {
        _powercellLocationInt = 1;
      } else if (team.powerCellLocation == PowerCellLocation.Lower) {
        _powercellLocationInt = 2;
      } else {
        _powercellLocationInt = 3;
      }
    }

    if (_newMatchInt == null) _newMatchInt = _matchInt;
    if (_newAutonomous == null) _newAutonomous = _autonomous;
    if (_newImageProcessing == null) _newImageProcessing = _imageProcessing;
    if (_newAutonomousStartingPointInt == null)
      _newAutonomousStartingPointInt = _autonomousStartingPointInt;
    if (_newDefense == null) _newDefense = _defense;
    if (_newPowercellLocationInt == null)
      _newPowercellLocationInt = _powercellLocationInt;

    Future _save() async {
      Match matchType;
      AutonomousStartingPoint autonomousStartingPoint;
      PowerCellLocation powerCellLocation;

      if (_newMatchInt == 1) {
        matchType = Match.Practice;
      } else if (_newMatchInt == 2) {
        matchType = Match.Playoff;
      } else {
        matchType = Match.Qual;
      }

      if (_newAutonomousStartingPointInt == 1) {
        autonomousStartingPoint = AutonomousStartingPoint.Left;
      } else if (_newAutonomousStartingPointInt == 2) {
        autonomousStartingPoint = AutonomousStartingPoint.Middle;
      } else {
        autonomousStartingPoint = AutonomousStartingPoint.Right;
      }

      if (_newPowercellLocationInt == 1) {
        powerCellLocation = PowerCellLocation.Inner;
      } else if (_newPowercellLocationInt == 2) {
        powerCellLocation = PowerCellLocation.Lower;
      } else {
        powerCellLocation = PowerCellLocation.Outer;
      }

      MatchScoutingTeam newTeam = MatchScoutingTeam(
        id: team.id,
        status: team.status,
        scoutName: _scoutName,
        teamName: _teamName,
        teamNo: _teamNumber,
        matchType: matchType,
        matchNo: _matchNumber,
        color: _robotColor,
        powerCellCount: _powercellCount,
        autonomous: _newAutonomous,
        imageProcessing: _newImageProcessing,
        autonomousStartingPoint: autonomousStartingPoint,
        powerCellLocation: powerCellLocation,
        defense: _newDefense,
        finalScore: _finalScore,
        defenseComment: _defenseComment,
        foul: _foul,
        techFoul: _techFoul,
        comment: _comment,
      );

      if (isNew) {
        await matchScoutingService.saveTeam(newTeam);
      } else {
        var updatedTeam = newTeam.changeStatus(Status.Unsynced);
        await matchScoutingService.updateTeam(updatedTeam);
      }
    }

    _validate() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        if (_scoutName == team.scoutName &&
            _teamName == team.teamName &&
            _teamNumber == team.teamNo &&
            _newMatchInt == _matchInt &&
            _matchNumber == team.matchNo &&
            _robotColor == team.color &&
            _powercellCount == team.powerCellCount &&
            _newAutonomous == _autonomous &&
            _newImageProcessing == _imageProcessing &&
            _newAutonomousStartingPointInt == _autonomousStartingPointInt &&
            _newPowercellLocationInt == _powercellLocationInt &&
            _newDefense == _defense &&
            _finalScore == team.finalScore &&
            _defenseComment == team.defenseComment &&
            _foul == team.foul &&
            _techFoul == team.techFoul &&
            _comment == team.comment) {
          showDialog(
            context: context,
            child: AlertDialog(
              title: Text("Error"),
              content: Text("You have to make changes to save team."),
              actions: [
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          await _save();
        }
      }
    }

    var matchTypeStrings = {1: "Practice", 2: "Playoff", 3: "Qual"};
    var autonomousStartingPointStrings = {1: "Left", 2: "Middle", 3: "Right"};
    var powercellLocationStrings = {1: "Inner", 2: "Lower", 3: "Outer"};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          team.teamName != "" ? team.teamName : "New Team",
        ),
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _validate();
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.05,
            vertical: deviceHeight * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: deviceWidth * 0.55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Scout name",
                        ),
                        initialValue: team.scoutName,
                        enabled: isCurrentUser,
                        validator: (value) {
                          if (value.length == 0) {
                            return "Scout name shouldn't be empty.";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _scoutName = newValue;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Team name",
                      initialValue: team.teamName,
                      keyboardType: TextInputType.name,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Team name shouldn't be empty.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _teamName = newValue;
                      },
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Team number",
                      initialValue: "${team.teamNo}",
                      keyboardType: TextInputType.number,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Team number shouldn't be empty.";
                        } else if (int.parse(value) is int == false) {
                          return "Team number should be integer.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _teamNumber = int.parse(newValue);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: deviceWidth * 0.3,
                      height: deviceHeight * 0.065,
                      child: DropdownButton(
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        value: _newMatchInt,
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              matchTypeStrings[_newMatchInt],
                            ),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              matchTypeStrings[_newMatchInt],
                            ),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              matchTypeStrings[_newMatchInt],
                            ),
                            value: 3,
                          ),
                        ],
                        disabledHint: Text(
                          matchTypeStrings[_newMatchInt],
                        ),
                        onChanged: isCurrentUser
                            ? (value) {
                                _newMatchInt = value;
                              }
                            : null,
                      ),
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Match number",
                      initialValue: team.matchNo,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Match number shouldn't be empty.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _matchNumber = newValue;
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Robot color",
                      initialValue: team.color,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Robot color shouldn't be empty.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _robotColor = newValue;
                      },
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Powercell count",
                      initialValue: "${team.powerCellCount}",
                      keyboardType: TextInputType.number,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Powercell count shouldn't be empty.";
                        } else if (int.parse(value) is int == false) {
                          return "Powercell count should be integer.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _powercellCount = int.parse(newValue);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Autonomous:"),
                        Switch(
                          value: _newAutonomous,
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                          onChanged: isCurrentUser
                              ? (value) {
                                  setState(() {
                                    _newAutonomous = value;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Image Processing:"),
                        Switch(
                          value: _newImageProcessing,
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                          onChanged: isCurrentUser
                              ? (value) {
                                  setState(() {
                                    _newImageProcessing = value;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: _newAutonomous ? deviceHeight * 0.05 : 0,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Autonomous Starting Point:"),
                      Container(
                        width: deviceWidth * 0.3,
                        height: deviceHeight * 0.065,
                        child: DropdownButton(
                          isExpanded: true,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          value: _newAutonomousStartingPointInt,
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                autonomousStartingPointStrings[1],
                              ),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                autonomousStartingPointStrings[2],
                              ),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                autonomousStartingPointStrings[3],
                              ),
                              value: 3,
                            ),
                          ],
                          disabledHint: Text(
                            autonomousStartingPointStrings[
                                _newAutonomousStartingPointInt],
                          ),
                          onChanged: isCurrentUser
                              ? (value) {
                                  setState(() {
                                    _newAutonomousStartingPointInt = value;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: deviceHeight * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Powercell Location:"),
                      Container(
                        width: deviceWidth * 0.3,
                        height: deviceHeight * 0.065,
                        child: DropdownButton(
                          isExpanded: true,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          value: _newPowercellLocationInt,
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                powercellLocationStrings[1],
                              ),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                powercellLocationStrings[2],
                              ),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                powercellLocationStrings[3],
                              ),
                              value: 3,
                            ),
                          ],
                          disabledHint: Text(
                            powercellLocationStrings[_newPowercellLocationInt],
                          ),
                          onChanged: isCurrentUser
                              ? (value) {
                                  setState(() {
                                    _newPowercellLocationInt = value;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Defense: "),
                        Switch(
                          value: _newDefense,
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                          onChanged: isCurrentUser
                              ? (value) {
                                  setState(() {
                                    _newDefense = value;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Final Score",
                      initialValue: "${team.finalScore}",
                      keyboardType: TextInputType.number,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Final score shouldn't be empty.";
                        } else if (int.parse(value) is int == false) {
                          return "Final score should be integer.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _finalScore = int.parse(newValue);
                      },
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: _newDefense ? deviceHeight * 0.1 : 0,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    initialValue: team.defenseComment,
                    decoration: InputDecoration(
                      labelText: "Defense comment",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    enabled: isCurrentUser,
                    validator: (value) {
                      if (_newDefense) {
                        if (value.length == 0) {
                          return "Defense comment shouldn't be empty.";
                        }
                        return null;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _defenseComment = newValue;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Foul",
                      initialValue: "${team.foul}",
                      keyboardType: TextInputType.number,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Foul shouldn't be empty.";
                        } else if (int.parse(value) is int == false) {
                          return "Foul should be integer.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _foul = int.parse(newValue);
                      },
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Tech Foul",
                      initialValue: "${team.techFoul}",
                      keyboardType: TextInputType.number,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Tech foul shouldn't be empty.";
                        } else if (int.parse(value) is int == false) {
                          return "Tech foul should be integer.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _techFoul = int.parse(newValue);
                      },
                    ),
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  initialValue: team.comment,
                  decoration: InputDecoration(
                    labelText: "Comment",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  enabled: isCurrentUser,
                  validator: (value) {
                    if (value.length == 0) {
                      return "Comment shouldn't be empty.";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _comment = newValue;
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
                FlatButton(
                  onPressed: () async {
                    await blueAllianceService
                        .goTeamPage(_teamNumber ?? team.teamNo);
                  },
                  child: Text("Go to Team's Blue Alliance Page"),
                  minWidth: double.infinity,
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
