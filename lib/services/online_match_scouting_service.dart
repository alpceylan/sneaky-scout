import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import './authentication_service.dart';
import './match_scouting_service.dart';
import '../services/google_sheets_service.dart';

// Models
import '../models/match_scouting_team.dart';

class OnlineMatchScoutingService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  MatchScoutingService _matchScoutingService = MatchScoutingService();
  GoogleSheetsService _sheetsService = GoogleSheetsService();

  Future<void> saveTeam(MatchScoutingTeam team) async {
    var newTeam = team.changeStatus(Status.Synced);

    await _firestore
        .collection('match_scouting')
        .add(await newTeam.mapTeam(true));

    await _sheetsService.syncMatchScout(newTeam);

    await _matchScoutingService.updateTeam(newTeam);
  }

  Future<void> updateTeam(MatchScoutingTeam team, int id) async {
    await _firestore.collection('match_scouting').doc("$id").update(
          await team.mapTeam(true),
        );
  }

  Future<List<MatchScoutingTeam>> getTeams() async {
    List<MatchScoutingTeam> teams = [];

    QuerySnapshot result = await _firestore
        .collection('match_scouting')
        .orderBy('id', descending: false)
        .get();

    result.docs.forEach((teamMap) {
      var team = MatchScoutingTeam().unmapTeam(teamMap.data(), true);
      teams.add(team);
    });

    return teams;
  }

  Future<void> deleteTeam(int id) async {
    await _firestore.collection('match_scouting').doc("$id").delete();
  }
}
