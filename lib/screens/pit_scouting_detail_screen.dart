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

  int _chassisTypeInt;
  bool _climbing;
  bool _imageProcessing;
  int _imageProcessingTypeInt;
  int _shooterTypeInt;

  int _newChassisTypeInt;
  bool _newClimbing;
  bool _newImageProcessing;
  int _newImageProcessingTypeInt;
  int _newShooterTypeInt;

  String _climbingComment;

  @override
  Widget build(BuildContext context) {
    final PitScoutingTeam team =
        ModalRoute.of(context).settings.arguments as PitScoutingTeam;

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    if (_chassisTypeInt == null) {
      if (team.chassisType == Chassis.X) {
        _chassisTypeInt = 1;
      } else if (team.chassisType == Chassis.Y) {
        _chassisTypeInt = 2;
      } else {
        _chassisTypeInt = 3;
      }
    }

    if (_climbing == null) _climbing = team.climbing;
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

    if (_newChassisTypeInt == null) _newChassisTypeInt = _chassisTypeInt;
    if (_newClimbing == null) _newClimbing = _climbing;
    if (_newImageProcessing == null) _newImageProcessing = _imageProcessing;
    if (_newShooterTypeInt == null) _newShooterTypeInt = _shooterTypeInt;

    return Scaffold(
      appBar: AppBar(
        title: Text(team.teamName),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
