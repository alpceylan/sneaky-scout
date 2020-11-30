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
  final Status status;
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
    this.status = Status.Unsynced,
    this.scoutName,
    this.teamName,
    this.teamNo,
    this.matchType,
    this.matchNo,
    this.color,
    this.powerCellCount,
    this.powerCellLocation,
    this.autonomous,
    this.autonomousStartingPoint,
    this.comment = "",
    this.defense,
    this.defenseComment = "",
    this.foul,
    this.techFoul,
    this.imageProcessing,
    this.finalScore,
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

  Map<String, dynamic> mapTeam() {
    Map<String, dynamic> _map = {
      // Firebase User kullanılmaya başlandığında buraya user id eklenecek.
      "status": statusString,
      "scoutName": scoutName,
      "teamName": teamName,
      "teamNo": teamNo,
      "matchType": matchTypeString,
      "matchNo": matchNo,
      "color": color,
      "powerCellCount": powerCellCount,
      "powerCellLocation": powerCellLocationString,
      "autonomous": autonomous ? 1 : 0,
      "autonomousStartingPoint": autonomousStartingPointString,
      "comment": comment,
      "defense": defense ? 1 : 0,
      "defenseComment": defenseComment,
      "foul": foul,
      "techFoul": techFoul,
      "imageProcessing": imageProcessing ? 1 : 0,
      "finalScore": finalScore,
    };

    return _map;
  }

  MatchScoutingTeam unmapTeam(Map<String, dynamic> teamMap) {
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
      status: teamMap["status"] == 'synced' ? Status.Synced : Status.Unsynced,
      scoutName: teamMap["scoutName"],
      teamName: teamMap["teamName"],
      teamNo: teamMap["teamNo"],
      matchType: matchType,
      matchNo: teamMap["matchNo"],
      color: teamMap["color"],
      powerCellCount: teamMap["powerCellCount"],
      powerCellLocation: powerCellLocation,
      autonomous: teamMap["autonomous"] == 1 ? true : false,
      autonomousStartingPoint: autonomousStartingPoint,
      comment: teamMap["comment"],
      defense: teamMap["defense"] == 1 ? true : false,
      defenseComment: teamMap["defenseComment"],
      foul: teamMap["foul"],
      techFoul: teamMap["techFoul"],
      imageProcessing: teamMap["imageProcessing"] == 1 ? true : false,
      finalScore: teamMap["finalScore"],
    );

    return team;
  }
}