import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import './authentication_service.dart';
import './match_scouting_service.dart';

// Models
import '../models/match_scouting_team.dart';

class OnlineMatchScoutingService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthenticationService _authService = AuthenticationService();
  MatchScoutingService _matchScoutingService = MatchScoutingService();

  Future<void> saveTeam(MatchScoutingTeam team) async {
    User currentUser = await _authService.getUser();

    var newTeam = team.changeStatus(Status.Synced);

    await _firestore
        .collection('match_scouting')
        .doc(currentUser.uid)
        .collection('scouts')
        .doc("${team.id}")
        .set(
          await newTeam.mapTeam(true),
        );

    await _matchScoutingService.updateTeam(newTeam);
  }

  Future<void> updateTeam(MatchScoutingTeam team, int id) async {
    User currentUser = await _authService.getUser();

    await _firestore
        .collection('match_scouting')
        .doc(currentUser.uid)
        .collection('scouts')
        .doc("$id")
        .update(
          await team.mapTeam(true),
        );
  }

  Future<List<DocumentSnapshot>> getTeams() async {
    User currentUser = await _authService.getUser();

    QuerySnapshot result = await _firestore
        .collection('match_scouting')
        .doc(currentUser.uid)
        .collection('scouts')
        .orderBy('id', descending: false)
        .get();

    return result.docs;
  }

  Future<void> deleteNote(int id) async {
    User currentUser = await _authService.getUser();

    await _firestore
        .collection('match_scouting')
        .doc(currentUser.uid)
        .collection('scouts')
        .doc("$id")
        .delete();
  }
}
