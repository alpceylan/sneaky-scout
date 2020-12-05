import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Services
import '../../services/pit_scouting_service.dart';
import '../../services/blue_alliance_service.dart';
import '../../services/authentication_service.dart';

// Models
import '../../models/pit_scouting_team.dart';

// Widgets
import '../../widgets/custom_text_input.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/comment_box.dart';

// Enums
import '../../enums/pit_scouting_enums.dart';

class PitScoutingDetailScreen extends StatefulWidget {
  static const routeName = '/pit-scouting-detail';

  @override
  _PitScoutingDetailScreenState createState() =>
      _PitScoutingDetailScreenState();
}

class _PitScoutingDetailScreenState extends State<PitScoutingDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final PitScoutingService pitScoutingService = PitScoutingService();
  final BlueAllianceService blueAllianceService = BlueAllianceService();
  final AuthenticationService authService = AuthenticationService();

  final ImagePicker picker = ImagePicker();

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
  String _imageString;

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
  String _newImageString;

  String _scoutName;
  String _teamName;
  int _teamNumber;
  int _maxBalls;
  String _climbingComment;
  String _autonomousComment;
  String _extra;
  String _comment;

  @override
  Widget build(BuildContext context) {
    final PitScoutingTeam team =
        ModalRoute.of(context).settings.arguments as PitScoutingTeam;
    final bool isNew = team.id == null ? true : false;
    final bool isCurrentUser = team.scoutName == ""
        ? true
        : team.userId == authService.currentUser.uid;

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

    if (_imageString == null) _imageString = team.imageString;

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
    if (_newImageString == null) _newImageString = _imageString;

    Future _save() async {
      Chassis chassisType;
      ImageProcessing imageProcessingType;
      Shooter shooterType;
      Hood hoodType;
      Intake intakeType;
      Funnel funnelType;

      if (chassisType == null) {
        if (_newChassisTypeInt == 1) {
          chassisType = Chassis.X;
        }
        if (_newChassisTypeInt == 2) {
          chassisType = Chassis.Y;
        } else {
          chassisType = Chassis.Z;
        }
      }

      if (imageProcessingType == null) {
        if (_newImageProcessingTypeInt == 1) {
          imageProcessingType = ImageProcessing.Custom;
        }
        if (_newImageProcessingTypeInt == 2) {
          imageProcessingType = ImageProcessing.Limelight;
        }
      }

      if (shooterType == null) {
        if (_newShooterTypeInt == 1) {
          shooterType = Shooter.LowGoal;
        }
        if (_newShooterTypeInt == 2) {
          shooterType = Shooter.OneWheel;
        } else {
          shooterType = Shooter.TwoWheel;
        }
      }

      if (hoodType == null) {
        if (_newHoodTypeInt == 1) {
          hoodType = Hood.X;
        }
        if (_newHoodTypeInt == 2) {
          hoodType = Hood.Y;
        } else {
          hoodType = Hood.Z;
        }
      }

      if (intakeType == null) {
        if (_newIntakeTypeInt == 1) {
          intakeType = Intake.X;
        }
        if (_newIntakeTypeInt == 2) {
          intakeType = Intake.Y;
        } else {
          intakeType = Intake.Z;
        }
      }

      if (funnelType == null) {
        if (_newFunnelTypeInt == 1) {
          funnelType = Funnel.X;
        }
        if (_newFunnelTypeInt == 2) {
          funnelType = Funnel.Y;
        } else {
          funnelType = Funnel.Z;
        }
      }

      PitScoutingTeam newTeam = PitScoutingTeam(
        id: team.id,
        status: team.status,
        scoutName: _scoutName,
        teamName: _teamName,
        teamNo: _teamNumber,
        imageUrl: team.imageUrl,
        imageString: _newImageString,
        chassisType: chassisType,
        climbing: _newClimbing,
        climbingComment: _climbingComment,
        imageProcessing: _newImageProcessing,
        imageProcessingType: imageProcessingType,
        shooterType: shooterType,
        hoodType: hoodType,
        intake: _newIntake,
        intakeType: intakeType,
        funnelType: funnelType,
        maxBalls: _maxBalls,
        autonomous: _newAutonomous,
        autonomousComment: _autonomousComment,
        extra: _extra,
        comment: _comment,
      );

      if (isNew) {
        await pitScoutingService.saveTeam(newTeam);
      } else {
        var updatedTeam = newTeam.changeStatus(Status.Unsynced);
        await pitScoutingService.updateTeam(updatedTeam);
      }
    }

    var imageProcessingTypeStrings = {1: "Custom", 2: "Limelight"};
    var shooterTypeStrings = {1: "Lowgoal", 2: "One Wheel", 3: "Two Wheel"};
    var hoodTypeStrings = {1: "Hood X", 2: "Hood Y", 3: "Hood Z"};
    var intakeTypeStrings = {1: "Intake X", 2: "Intake Y", 3: "Intake Z"};
    var chassisTypeStrings = {1: "Chassis X", 2: "Chassis Y", 3: "Chassis Z"};

    _validate() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        if (_scoutName == team.scoutName &&
            _teamName == team.teamName &&
            _teamNumber == team.teamNo &&
            _maxBalls == team.maxBalls &&
            _climbingComment == team.climbingComment &&
            _autonomousComment == team.autonomousComment &&
            _extra == team.extra &&
            _comment == team.comment &&
            _newClimbing == _climbing &&
            _newImageProcessing == _imageProcessing &&
            _newImageProcessingTypeInt == _imageProcessingTypeInt &&
            _newShooterTypeInt == _shooterTypeInt &&
            _newIntake == _intake &&
            _newHoodTypeInt == _hoodTypeInt &&
            _newIntakeTypeInt == _intakeTypeInt &&
            _newFunnelTypeInt == _funnelTypeInt &&
            _newAutonomous == _autonomous &&
            _newChassisTypeInt == _chassisTypeInt &&
            _newImageString == _imageString) {
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
        } else if (_newImageString == "") {
          showDialog(
            context: context,
            child: AlertDialog(
              title: Text("Error"),
              content: Text("You have to upload a image to save team."),
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
          _save();
        }
      }
    }

    Future _getImageFromCamera() async {
      final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      setState(() {
        if (pickedFile != null) {
          var _image = File(pickedFile.path);
          List<int> bytes = _image.readAsBytesSync();
          _newImageString = base64Encode(bytes);
        }
      });
    }

    Future _getImageFromGallery() async {
      final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      setState(() {
        if (pickedFile != null) {
          var _image = File(pickedFile.path);
          List<int> bytes = _image.readAsBytesSync();
          _newImageString = base64Encode(bytes);
        }
      });
    }

    void _showPicker(BuildContext ctx) {
      showModalBottomSheet(
        context: ctx,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                      ),
                      title: Text('Photo Library'),
                      onTap: () {
                        _getImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                    ),
                    title: Text('Camera'),
                    onTap: () {
                      _getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextInput(
                      labelText: "Scout name",
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
                    GestureDetector(
                      onTap: isCurrentUser
                          ? () {
                              _showPicker(context);
                            }
                          : null,
                      child: CircleAvatar(
                        backgroundImage: team.imageUrl != ""
                            ? NetworkImage(team.imageUrl)
                            : _newImageString != ""
                                ? MemoryImage(
                                    base64Decode(_newImageString),
                                  )
                                : AssetImage(
                                    "assets/images/robot.png",
                                  ),
                        minRadius: deviceWidth * 0.09,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextInput(
                      labelText: "Team name",
                      initialValue: team.teamName,
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
                      labelText: "Team number",
                      initialValue: "${team.teamNo}",
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Team number shouldn't be empty.";
                        } else if (int.tryParse(value) == null) {
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
                  children: [
                    Row(
                      children: [
                        Text("Climbing:"),
                        Switch(
                          value: _newClimbing,
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                          onChanged: isCurrentUser
                              ? (value) {
                                  setState(() {
                                    _newClimbing = value;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    CustomTextInput(
                      labelText: "Max balls",
                      initialValue: "${team.maxBalls}",
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Max balls shouldn't be empty.";
                        } else if (int.tryParse(value) == null) {
                          return "Max balls should be integer.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _maxBalls = int.parse(newValue);
                      },
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: _newClimbing ? deviceHeight * 0.1 : 0,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: CommentBox(
                    initialValue: team.climbingComment,
                    value: _climbingComment,
                    labelText: "Climbing comment",
                    maxLines: 2,
                    isCurrentUser: isCurrentUser,
                    visible: _newClimbing,
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
                    CustomDropdownButton(
                      menuMap: shooterTypeStrings,
                      value: _newShooterTypeInt,
                      isCurrentUser: isCurrentUser,
                      onChanged: (newValue) {
                        setState(() {
                          _newShooterTypeInt = newValue;
                        });
                      },
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
                      CustomDropdownButton(
                        menuMap: imageProcessingTypeStrings,
                        value: _newImageProcessingTypeInt,
                        isCurrentUser: isCurrentUser,
                        onChanged: (newValue) {
                          setState(() {
                            _newImageProcessingTypeInt = newValue;
                          });
                        },
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
                          onChanged: isCurrentUser
                              ? (value) {
                                  setState(() {
                                    _newIntake = value;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    CustomDropdownButton(
                      menuMap: hoodTypeStrings,
                      value: _newHoodTypeInt,
                      isCurrentUser: isCurrentUser,
                      onChanged: (newValue) {
                        setState(() {
                          _newHoodTypeInt = newValue;
                        });
                      },
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
                      CustomDropdownButton(
                        menuMap: intakeTypeStrings,
                        value: _newIntakeTypeInt,
                        isCurrentUser: isCurrentUser,
                        onChanged: (newValue) {
                          setState(() {
                            _newIntakeTypeInt = newValue;
                          });
                        },
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
                    CustomDropdownButton(
                      menuMap: chassisTypeStrings,
                      value: _newChassisTypeInt,
                      isCurrentUser: isCurrentUser,
                      onChanged: (newValue) {
                        setState(() {
                          _newChassisTypeInt = newValue;
                        });
                      },
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: _newAutonomous ? deviceHeight * 0.1 : 0,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: CommentBox(
                    initialValue: team.autonomousComment,
                    value: _autonomousComment,
                    labelText: "Autonomous comment",
                    maxLines: 2,
                    isCurrentUser: isCurrentUser,
                    visible: _newAutonomous,
                  ),
                ),
                CommentBox(
                  initialValue: team.extra,
                  value: _extra,
                  labelText: "Extra",
                  maxLines: 3,
                  isCurrentUser: isCurrentUser,
                ),
                CommentBox(
                  initialValue: team.comment,
                  value: _comment,
                  labelText: "Comment",
                  maxLines: 3,
                  isCurrentUser: isCurrentUser,
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
