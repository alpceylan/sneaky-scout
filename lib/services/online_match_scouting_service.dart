import 'package:cloud_firestore/cloud_firestore.dart';

// Services
import './match_scouting_service.dart';

// Models
import '../models/match_scouting_team.dart';

// Enums
import '../enums/match_scouting_enums.dart';

class OnlineMatchScoutingService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  MatchScoutingService _matchScoutingService = MatchScoutingService();

  Future<void> saveTeam(MatchScoutingTeam team) async {
    var newTeam = team.changeStatus(Status.Synced);

    await _firestore
        .collection('match_scouting')
        .doc("${newTeam.teamNo}")
        .set(await newTeam.toFirebase());

    await _matchScoutingService.updateTeam(newTeam);
  }

  Future<List<MatchScoutingTeam>> getTeams() async {
    List<MatchScoutingTeam> teams = [];

    QuerySnapshot result = await _firestore.collection('match_scouting').get();

    result.docs.forEach((teamMap) {
      var team = MatchScoutingTeam.fromFirebase(teamMap.data());
      teams.add(team);
    });

    return teams;
  }

  Future<void> deleteTeam(MatchScoutingTeam team) async {
    await _firestore
        .collection('match_scouting')
        .doc("${team.teamNo}")
        .delete();
  }
}
