// Services
import '../services/authentication_service.dart';

enum Status {
  Synced,
  Unsynced,
}

enum Match {
  Practice,
  Qual,
  Playoff,
}

enum PowerCellLocation {
  Inner,
  Lower,
  Outer,
}

enum AutonomousStartingPoint {
  Right,
  Middle,
  Left,
}

class MatchScoutingTeam {
  AuthenticationService _authService = AuthenticationService();

  final int id;
  final Status status;
  final String userId;
  final String scoutName;
  final String teamName;
  final int teamNo;
  final Match matchType;
  final String matchNo;
  final String color;
  final int powerCellCount;
  final PowerCellLocation powerCellLocation;
  final bool autonomous;
  final AutonomousStartingPoint autonomousStartingPoint;
  final String comment;
  final bool defense;
  final String defenseComment;
  final int foul;
  final int techFoul;
  final bool imageProcessing;
  final int finalScore;

  MatchScoutingTeam({
    this.id,
    this.status = Status.Unsynced,
    this.userId = "",
    this.scoutName = "",
    this.teamName = "",
    this.teamNo = 0,
    this.matchType,
    this.matchNo = "",
    this.color = "",
    this.powerCellCount = 0,
    this.powerCellLocation,
    this.autonomous = false,
    this.autonomousStartingPoint,
    this.comment = "",
    this.defense = false,
    this.defenseComment = "",
    this.foul = 0,
    this.techFoul = 0,
    this.imageProcessing = false,
    this.finalScore = 0,
  });

  String get statusString {
    return status == Status.Synced ? "synced" : "unsynced";
  }

  String get matchTypeString {
    switch (matchType) {
      case Match.Qual:
        return "qual";
      case Match.Practice:
        return "practice";
      case Match.Playoff:
        return "playoff";
    }
    return null;
  }

  String get powerCellLocationString {
    switch (powerCellLocation) {
      case PowerCellLocation.Inner:
        return "inner";
      case PowerCellLocation.Lower:
        return "lower";
      case PowerCellLocation.Outer:
        return "outer";
    }
    return null;
  }

  String get autonomousStartingPointString {
    switch (autonomousStartingPoint) {
      case AutonomousStartingPoint.Left:
        return "left";
      case AutonomousStartingPoint.Middle:
        return "middle";
      case AutonomousStartingPoint.Right:
        return "right";
    }
    return null;
  }

  MatchScoutingTeam changeStatus(Status newStatus) {
    var newTeam = MatchScoutingTeam(
      id: id,
      status: newStatus,
      userId: userId,
      scoutName: scoutName,
      teamName: teamName,
      teamNo: teamNo,
      matchType: matchType,
      matchNo: matchNo,
      color: color,
      powerCellCount: powerCellCount,
      powerCellLocation: powerCellLocation,
      autonomous: autonomous,
      autonomousStartingPoint: autonomousStartingPoint,
      comment: comment,
      defense: defense,
      defenseComment: defenseComment,
      foul: foul,
      techFoul: techFoul,
      imageProcessing: imageProcessing,
      finalScore: finalScore,
    );

    return newTeam;
  }

  Future<Map<String, dynamic>> mapTeam(bool isOnline) async {
    Map<String, dynamic> _map;
    if (id == null) {
      _map = {
        "status": statusString,
        "userId": _authService.currentUser.uid,
        "scoutName": scoutName,
        "teamName": teamName,
        "teamNo": teamNo,
        "matchType": matchTypeString,
        "matchNo": matchNo,
        "color": color,
        "powerCellCount": powerCellCount,
        "powerCellLocation": powerCellLocationString,
        "autonomous": isOnline
            ? autonomous
            : autonomous
                ? 1
                : 0,
        "autonomousStartingPoint": autonomousStartingPointString,
        "comment": comment,
        "defense": isOnline
            ? defense
            : defense
                ? 1
                : 0,
        "defenseComment": defenseComment,
        "foul": foul,
        "techFoul": techFoul,
        "imageProcessing": isOnline
            ? imageProcessing
            : imageProcessing
                ? 1
                : 0,
        "finalScore": finalScore,
      };
    } else {
      _map = {
        "id": id,
        "status": statusString,
        "userId": _authService.currentUser.uid,
        "scoutName": scoutName,
        "teamName": teamName,
        "teamNo": teamNo,
        "matchType": matchTypeString,
        "matchNo": matchNo,
        "color": color,
        "powerCellCount": powerCellCount,
        "powerCellLocation": powerCellLocationString,
        "autonomous": isOnline
            ? autonomous
            : autonomous
                ? 1
                : 0,
        "autonomousStartingPoint": autonomousStartingPointString,
        "comment": comment,
        "defense": isOnline
            ? defense
            : defense
                ? 1
                : 0,
        "defenseComment": defenseComment,
        "foul": foul,
        "techFoul": techFoul,
        "imageProcessing": isOnline
            ? imageProcessing
            : imageProcessing
                ? 1
                : 0,
        "finalScore": finalScore,
      };
    }

    return _map;
  }

  MatchScoutingTeam unmapTeam(Map<String, dynamic> teamMap, bool isOnline) {
    Match matchType;
    PowerCellLocation powerCellLocation;
    AutonomousStartingPoint autonomousStartingPoint;

    if (teamMap["matchType"] == "practice") {
      matchType = Match.Practice;
    } else if (teamMap["matchType"] == "playoff") {
      matchType = Match.Playoff;
    } else {
      matchType = Match.Qual;
    }

    if (teamMap["powerCellLocation"] == "inner") {
      powerCellLocation = PowerCellLocation.Inner;
    } else if (teamMap["powerCellLocation"] == "lower") {
      powerCellLocation = PowerCellLocation.Lower;
    } else {
      powerCellLocation = PowerCellLocation.Outer;
    }

    if (teamMap["autonomousStartingPoint"] == "left") {
      autonomousStartingPoint = AutonomousStartingPoint.Left;
    } else if (teamMap["autonomousStartingPoint"] == "middle") {
      autonomousStartingPoint = AutonomousStartingPoint.Middle;
    } else {
      autonomousStartingPoint = AutonomousStartingPoint.Right;
    }

    var team = MatchScoutingTeam(
      id: teamMap["id"],
      status: teamMap["status"] == 'synced' ? Status.Synced : Status.Unsynced,
      userId: teamMap["userId"],
      scoutName: teamMap["scoutName"],
      teamName: teamMap["teamName"],
      teamNo: teamMap["teamNo"],
      matchType: matchType,
      matchNo: teamMap["matchNo"],
      color: teamMap["color"],
      powerCellCount: teamMap["powerCellCount"],
      powerCellLocation: powerCellLocation,
      autonomous: isOnline
          ? teamMap["autonomous"]
          : teamMap["autonomous"] == 1
              ? true
              : false,
      autonomousStartingPoint: autonomousStartingPoint,
      comment: teamMap["comment"],
      defense: isOnline
          ? teamMap["defense"]
          : teamMap["defense"] == 1
              ? true
              : false,
      defenseComment: teamMap["defenseComment"],
      foul: teamMap["foul"],
      techFoul: teamMap["techFoul"],
      imageProcessing: isOnline
          ? teamMap["imageProcessing"]
          : teamMap["imageProcessing"] == 1
              ? true
              : false,
      finalScore: teamMap["finalScore"],
    );

    return team;
  }

  List<dynamic> mapTeamForSheet() {
    return [
      statusString,
      _authService.currentUser.uid,
      scoutName,
      teamName,
      teamNo,
      matchTypeString,
      matchNo,
      color,
      powerCellCount,
      powerCellLocationString,
      autonomous,
      autonomousStartingPointString,
      comment,
      defense,
      defenseComment,
      foul,
      techFoul,
      imageProcessing,
      finalScore,
      id,
    ];
  }
}
