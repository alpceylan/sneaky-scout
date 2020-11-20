import 'package:flutter/material.dart';

// Models
import '../models/matchScoutingTeam.dart';

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

  int _matchInt;
  bool _autonomous;
  bool _imageProcessing;
  int _autonomousStartingPointInt;
  bool _defense;

  int _newMatchInt;
  bool _newAutonomous;
  bool _newImageProcessing;
  int _newAutonomousStartingPointInt;
  bool _newDefense;

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

    if (_newMatchInt == null) _newMatchInt = _matchInt;
    if (_newAutonomous == null) _newAutonomous = _autonomous;
    if (_newImageProcessing == null) _newImageProcessing = _imageProcessing;
    if (_newAutonomousStartingPointInt == null)
      _newAutonomousStartingPointInt = _autonomousStartingPointInt;
    if (_newDefense == null) _newDefense = _defense;

    _validate() {
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
          // Saving functions will be here.
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${team.teamName}"),
        actions: [
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
                            child: Text("Practice"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("Playoff"),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text("Qual"),
                            value: 3,
                          ),
                        ],
                        onChanged: (value) {
                          _newMatchInt = value;
                        },
                      ),
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Match number",
                      initialValue: team.matchNo,
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
                          onChanged: (value) {
                            setState(() {
                              _newAutonomous = value;
                            });
                          },
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
                          onChanged: (value) {
                            setState(() {
                              _newImageProcessing = value;
                            });
                          },
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
                              child: Text("Left"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Middle"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Right"),
                              value: 3,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _newAutonomousStartingPointInt = value;
                            });
                          },
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
                          onChanged: (value) {
                            setState(() {
                              _newDefense = value;
                            });
                          },
                        ),
                      ],
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Final Score",
                      initialValue: "${team.finalScore}",
                      keyboardType: TextInputType.number,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
