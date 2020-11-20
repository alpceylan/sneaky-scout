import 'dart:convert';

import 'package:flutter/material.dart';

// Models
import '../models/pitScoutingTeam.dart';

// Widgets
import '../widgets/custom_text_input.dart';

class PitScoutingDetailScreen extends StatefulWidget {
  static const routeName = '/pit-scouting-detail';

  @override
  _PitScoutingDetailScreenState createState() =>
      _PitScoutingDetailScreenState();
}

class _PitScoutingDetailScreenState extends State<PitScoutingDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _climbing;
  bool _imageProcessing;
  int _imageProcessingTypeInt;
  int _shooterTypeInt;
  bool _intake;
  int _hoodTypeInt;
  int _intakeTypeInt;
  int _funnelTypeInt;
  bool _autonomous;
  int _chassisTypeInt;

  bool _newClimbing;
  bool _newImageProcessing;
  int _newImageProcessingTypeInt;
  int _newShooterTypeInt;
  bool _newIntake;
  int _newHoodTypeInt;
  int _newIntakeTypeInt;
  int _newFunnelTypeInt;
  bool _newAutonomous;
  int _newChassisTypeInt;

  int _maxBalls;
  String _climbingComment;
  String _autonomousComment;
  String _extra;
  String _comment;

  @override
  Widget build(BuildContext context) {
    final PitScoutingTeam team =
        ModalRoute.of(context).settings.arguments as PitScoutingTeam;

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    if (_climbing == null) _climbing = team.climbing;
    if (_maxBalls == null) _maxBalls = team.maxBalls;
    if (_imageProcessing == null) _imageProcessing = team.imageProcessing;

    if (_shooterTypeInt == null) {
      if (team.shooterType == Shooter.LowGoal) {
        _shooterTypeInt = 1;
      } else if (team.shooterType == Shooter.OneWheel) {
        _shooterTypeInt = 2;
      } else {
        _shooterTypeInt = 3;
      }
    }

    if (_imageProcessingTypeInt == null)
      _imageProcessingTypeInt =
          team.imageProcessingType == ImageProcessing.Custom ? 1 : 2;

    if (_intake == null) _intake = team.intake;

    if (_hoodTypeInt == null) {
      if (team.hoodType == Hood.X) {
        _hoodTypeInt = 1;
      } else if (team.hoodType == Hood.Y) {
        _hoodTypeInt = 2;
      } else {
        _hoodTypeInt = 3;
      }
    }

    if (_intakeTypeInt == null) {
      if (team.intakeType == Intake.X) {
        _intakeTypeInt = 1;
      } else if (team.intakeType == Intake.Y) {
        _intakeTypeInt = 2;
      } else {
        _intakeTypeInt = 3;
      }
    }

    if (_funnelTypeInt == null) {
      if (team.funnelType == Funnel.X) {
        _funnelTypeInt = 1;
      } else if (team.funnelType == Funnel.Y) {
        _funnelTypeInt = 2;
      } else {
        _funnelTypeInt = 3;
      }
    }

    if (_autonomous == null) _autonomous = team.autonomous;

    if (_chassisTypeInt == null) {
      if (team.chassisType == Chassis.X) {
        _chassisTypeInt = 1;
      } else if (team.chassisType == Chassis.Y) {
        _chassisTypeInt = 2;
      } else {
        _chassisTypeInt = 3;
      }
    }

    if (_newClimbing == null) _newClimbing = _climbing;
    if (_newImageProcessing == null) _newImageProcessing = _imageProcessing;
    if (_newShooterTypeInt == null) _newShooterTypeInt = _shooterTypeInt;
    if (_newImageProcessingTypeInt == null)
      _newImageProcessingTypeInt = _imageProcessingTypeInt;
    if (_newIntake == null) _newIntake = _intake;
    if (_newHoodTypeInt == null) _newHoodTypeInt = _hoodTypeInt;
    if (_newFunnelTypeInt == null) _newFunnelTypeInt = _funnelTypeInt;
    if (_newIntakeTypeInt == null) _newIntakeTypeInt = _intakeTypeInt;
    if (_newAutonomous == null) _newAutonomous = _autonomous;
    if (_newChassisTypeInt == null) _newChassisTypeInt = _chassisTypeInt;

    return Scaffold(
      appBar: AppBar(
        title: Text(team.teamName),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              print("save button clicked.");
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Scout name",
                      initialValue: team.scoutName,
                    ),
                    CircleAvatar(
                      backgroundImage: MemoryImage(
                        base64Decode(team.imageString),
                      ),
                      minRadius: deviceWidth * 0.09,
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
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Team number",
                      initialValue: "${team.teamNo}",
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Climbing:"),
                        Switch(
                          value: _newClimbing,
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              _newClimbing = value;
                            });
                          },
                        ),
                      ],
                    ),
                    CustomTextInput(
                      deviceWidth: deviceWidth,
                      labelText: "Max balls",
                      initialValue: "${team.maxBalls}",
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: _newClimbing ? deviceHeight * 0.1 : 0,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    initialValue: team.climbingComment,
                    decoration: InputDecoration(
                      labelText: "Climbing comment",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (_newClimbing) {
                        if (value.length == 0) {
                          return "Climbing comment shouldn't be empty.";
                        }
                        return null;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _climbingComment = newValue;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Container(
                      width: deviceWidth * 0.3,
                      height: deviceHeight * 0.065,
                      child: DropdownButton(
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        value: _newShooterTypeInt,
                        items: [
                          DropdownMenuItem(
                            child: Text("Low Goal"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("One Wheel"),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text("Two Wheel"),
                            value: 3,
                          ),
                        ],
                        onChanged: (value) {
                          _newShooterTypeInt = value;
                        },
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: _newImageProcessing ? deviceHeight * 0.05 : 0,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Image Processing Type:"),
                      Container(
                        width: deviceWidth * 0.3,
                        height: deviceHeight * 0.065,
                        child: DropdownButton(
                          isExpanded: true,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          value: _newImageProcessingTypeInt,
                          items: [
                            DropdownMenuItem(
                              child: Text("Custom"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Limelight"),
                              value: 2,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _newImageProcessingTypeInt = value;
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
                        Text("Intake:"),
                        Switch(
                          value: _newIntake,
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              _newIntake = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: deviceWidth * 0.3,
                      height: deviceHeight * 0.065,
                      child: DropdownButton(
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        value: _newHoodTypeInt,
                        items: [
                          DropdownMenuItem(
                            child: Text("Hood X"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("Hood Y"),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text("Hood Z"),
                            value: 3,
                          ),
                        ],
                        onChanged: (value) {
                          _newHoodTypeInt = value;
                        },
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: _newIntake ? deviceHeight * 0.05 : 0,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Intake Type:"),
                      Container(
                        width: deviceWidth * 0.3,
                        height: deviceHeight * 0.065,
                        child: DropdownButton(
                          isExpanded: true,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          value: _newIntakeTypeInt,
                          items: [
                            DropdownMenuItem(
                              child: Text("Intake X"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Intake Y"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Intake Z"),
                              value: 3,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _newIntakeTypeInt = value;
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
                        Text("Autonomous::"),
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
                    Container(
                      width: deviceWidth * 0.3,
                      height: deviceHeight * 0.065,
                      child: DropdownButton(
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        value: _newChassisTypeInt,
                        items: [
                          DropdownMenuItem(
                            child: Text("Chassis X"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("Chassis Y"),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text("Chassis Z"),
                            value: 3,
                          ),
                        ],
                        onChanged: (value) {
                          _newChassisTypeInt = value;
                        },
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: _newAutonomous ? deviceHeight * 0.1 : 0,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    initialValue: team.autonomousComment,
                    decoration: InputDecoration(
                      labelText: "Autonomous comment",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (_newClimbing) {
                        if (value.length == 0) {
                          return "Autonomous comment shouldn't be empty.";
                        }
                        return null;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _autonomousComment = newValue;
                    },
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  initialValue: team.extra,
                  decoration: InputDecoration(
                    labelText: "Extra",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value.length == 0) {
                      return "Extra shouldn't be empty.";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _extra = newValue;
                  },
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
