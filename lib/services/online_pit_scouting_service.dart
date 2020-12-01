import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import './authentication_service.dart';
import './pit_scouting_service.dart';

// Models
import '../models/pit_scouting_team.dart';

class OnlinePitScoutingService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthenticationService _authService = AuthenticationService();
  PitScoutingService _pitScoutingService = PitScoutingService();

  Future<void> saveTeam(PitScoutingTeam team) async {
    User currentUser = await _authService.getUser();

    var newTeam = team.changeStatus(Status.Synced);

    await _firestore
        .collection('pit_scouting')
        .doc(currentUser.uid)
        .collection('scouts')
        .doc("${team.id}")
        .set(
          await newTeam.mapTeam(true),
        );

    await _pitScoutingService.updateTeam(newTeam);
  }

  Future<void> updateTeam(PitScoutingTeam team, int id) async {
    User currentUser = await _authService.getUser();

    await _firestore
        .collection('pit_scouting')
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
        .collection('pit_scouting')
        .doc(currentUser.uid)
        .collection('scouts')
        .orderBy('id', descending: false)
        .get();

    return result.docs;
  }

  Future<void> deleteNote(int id) async {
    User currentUser = await _authService.getUser();

    await _firestore
        .collection('pit_scouting')
        .doc(currentUser.uid)
        .collection('scouts')
        .doc("$id")
        .delete();
  }
}
