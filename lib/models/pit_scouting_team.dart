import 'package:flutter/foundation.dart';

enum Status {
  Unsynced,
  Synced,
}

enum Chassis {
  X,
  Y,
  Z,
}

enum ImageProcessing {
  Custom,
  Limelight,
}

enum Shooter {
  OneWheel,
  TwoWheel,
  LowGoal,
}

enum Hood {
  X,
  Y,
  Z,
}

enum Intake {
  X,
  Y,
  Z,
}

enum Funnel {
  X,
  Y,
  Z,
}

class PitScoutingTeam {
  final Status status;
  final String scoutName;
  final String teamName;
  final int teamNo;
  final String
      imageUrl; // URL of image in Firebase Storage (Only if team is synced)
  final String
      imageString; // Base64 String for image (Only if team is unsynced)
  final Chassis chassisType;
  final bool climbing;
  final String climbingComment;
  final bool imageProcessing;
  final ImageProcessing imageProcessingType;
  final Shooter shooterType;
  final Hood hoodType;
  final bool intake;
  final Intake intakeType;
  final Funnel funnelType;
  final int maxBalls;
  final bool autonomous;
  final String autonomousComment;
  final String extra;
  final String comment;

  PitScoutingTeam({
    this.status = Status.Unsynced,
    @required this.scoutName,
    @required this.teamName,
    @required this.teamNo,
    this.imageUrl = "",
    this.imageString = "",
    @required this.chassisType,
    @required this.climbing,
    this.climbingComment = "",
    @required this.imageProcessing,
    this.imageProcessingType,
    @required this.shooterType,
    @required this.hoodType,
    @required this.intake,
    this.intakeType,
    @required this.funnelType,
    @required this.maxBalls,
    @required this.autonomous,
    this.autonomousComment = "",
    this.extra = "",
    this.comment = "",
  });

  String get statusString {
    return status == Status.Synced ? "synced" : "unsynced";
  }

  String get chassisTypeString {
    switch (chassisType) {
      case Chassis.X:
        return "x";
      case Chassis.Y:
        return "y";
      case Chassis.Z:
        return "z";
    }
    return null;
  }

  String get imageProcessingTypeString {
    switch (imageProcessingType) {
      case ImageProcessing.Custom:
        return "custom";
      case ImageProcessing.Limelight:
        return "unsynced";
    }
    return null;
  }

  String get shooterTypeString {
    switch (shooterType) {
      case Shooter.LowGoal:
        return "lowGoal";
      case Shooter.OneWheel:
        return "oneWheel";
      case Shooter.TwoWheel:
        return "twoWheel";
    }
    return null;
  }

  String get hoodTypeString {
    switch (hoodType) {
      case Hood.X:
        return "x";
      case Hood.Y:
        return "y";
      case Hood.Z:
        return "z";
    }
    return null;
  }

  String get intakeTypeString {
    switch (intakeType) {
      case Intake.X:
        return "x";
      case Intake.Y:
        return "y";
      case Intake.Z:
        return "z";
    }
    return null;
  }

  String get funnelTypeString {
    switch (funnelType) {
      case Funnel.X:
        return "x";
      case Funnel.Y:
        return "y";
      case Funnel.Z:
        return "z";
    }
    return null;
  }

  Map<String, dynamic> teamMap() {
    Map<String, dynamic> _map = {
      // USER ID Property will be added here after Firebase integration.
      "status": statusString,
      "scoutName": scoutName,
      "teamName": teamName,
      "teamNo": teamNo,
      "imageUrl": imageUrl,
      "imageString": imageString,
      "chassisType": chassisTypeString,
      "climbing": climbing ? 1 : 0,
      "climbingComment": climbingComment,
      "imageProcessing": imageProcessing ? 1 : 0,
      "imageProcessingType": imageProcessingTypeString,
      "shooterType": shooterTypeString,
      "hoodType": hoodTypeString,
      "intake": intake ? 1 : 0,
      "intakeType": intakeTypeString,
      "funnelType": funnelTypeString,
      "maxBalls": maxBalls,
      "autonomous": autonomous ? 1 : 0,
      "autonomousComment": autonomousComment,
      "extra": extra,
      "comment": comment,
    };

    return _map;
  }
}
