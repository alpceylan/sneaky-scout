import 'package:firebase_auth/firebase_auth.dart';

// Services
import '../services/authentication_service.dart';

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
  final int id;
  final Status status;
  final String userId;
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
    this.id,
    this.status = Status.Unsynced,
    this.userId = "",
    this.scoutName,
    this.teamName,
    this.teamNo,
    this.imageUrl = "",
    this.imageString = "",
    this.chassisType,
    this.climbing,
    this.climbingComment = "",
    this.imageProcessing,
    this.imageProcessingType,
    this.shooterType,
    this.hoodType,
    this.intake,
    this.intakeType,
    this.funnelType,
    this.maxBalls,
    this.autonomous,
    this.autonomousComment = "",
    this.extra = "",
    this.comment = "",
  });

  String get statusString {
    return status == Status.Synced ? "synced" : "unsynced";
  }

  Future<String> getUserId() async {
    AuthenticationService _authService = AuthenticationService();
    User user = await _authService.getUser();

    return user.uid;
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
        return "limelight";
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

  Future<Map<String, dynamic>> mapTeam() async {
    Map<String, dynamic> _map;
    if (id == null) {
      _map = {
        "status": statusString,
        "userId": await getUserId(),
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
    } else {
      _map = {
        "id": id,
        "status": statusString,
        "userId": await getUserId(),
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
    }

    return _map;
  }

  PitScoutingTeam unmapTeam(Map<String, dynamic> teamMap) {
    Status status;
    Chassis chassisType;
    ImageProcessing imageProcessingType;
    Shooter shooterType;
    Hood hoodType;
    Intake intakeType;
    Funnel funnelType;

    status = teamMap["status"] == "unsynced" ? Status.Unsynced : Status.Synced;

    if (teamMap["chassisType"] == "x") {
      chassisType = Chassis.X;
    }
    if (teamMap["chassisType"] == "y") {
      chassisType = Chassis.Y;
    } else {
      chassisType = Chassis.Z;
    }

    imageProcessingType = teamMap["imageProcessingType"] == "custom"
        ? ImageProcessing.Custom
        : ImageProcessing.Limelight;

    if (teamMap["shooterType"] == "lowGoal") {
      shooterType = Shooter.LowGoal;
    }
    if (teamMap["shooterType"] == "oneWheel") {
      shooterType = Shooter.OneWheel;
    } else {
      shooterType = Shooter.TwoWheel;
    }

    if (teamMap["hoodType"] == "x") {
      hoodType = Hood.X;
    }
    if (teamMap["hoodType"] == "y") {
      hoodType = Hood.Y;
    } else {
      hoodType = Hood.Z;
    }

    if (teamMap["intakeType"] == "x") {
      intakeType = Intake.X;
    }
    if (teamMap["intakeType"] == "y") {
      intakeType = Intake.Y;
    } else {
      intakeType = Intake.Z;
    }

    if (teamMap["funnelType"] == "x") {
      funnelType = Funnel.X;
    }
    if (teamMap["funnelType"] == "y") {
      funnelType = Funnel.Y;
    } else {
      funnelType = Funnel.Z;
    }

    var team = PitScoutingTeam(
      id: teamMap["id"],
      status: status,
      userId: teamMap["userId"],
      scoutName: teamMap["scoutName"],
      teamName: teamMap["teamName"],
      teamNo: teamMap["teamNo"],
      imageUrl: teamMap["imageUrl"],
      imageString: teamMap["imageString"],
      chassisType: chassisType,
      climbing: teamMap["climbing"] == 1 ? true : false,
      climbingComment: teamMap["climbingComment"],
      imageProcessing: teamMap["imageProcessing"] == 1 ? true : false,
      imageProcessingType: imageProcessingType,
      shooterType: shooterType,
      hoodType: hoodType,
      intake: teamMap["intake"] == 1 ? true : false,
      intakeType: intakeType,
      funnelType: funnelType,
      maxBalls: teamMap["maxBalls"],
      autonomous: teamMap["autonomous"] == 1 ? true : false,
      autonomousComment: teamMap["autonomousComment"],
      extra: teamMap["extra"],
      comment: teamMap["comment"],
    );

    return team;
  }
}
