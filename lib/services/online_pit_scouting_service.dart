import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Services
import './authentication_service.dart';
import './pit_scouting_service.dart';

// Models
import '../models/pit_scouting_team.dart';

// Enums
import '../enums/pit_scouting_enums.dart';

class OnlinePitScoutingService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  AuthenticationService _authService = AuthenticationService();
  PitScoutingService _pitScoutingService = PitScoutingService();

  Future<void> saveTeam(PitScoutingTeam team) async {
    User currentUser = _authService.currentUser;

    var newTeam = team.changeStatus(Status.Synced);

    final ref = _storage.ref().child('images').child(
        DateTime.now().toIso8601String() +
            currentUser.uid +
            "${newTeam.id}" +
            '.jpg');

    await ref.putString(
      newTeam.imageString,
      format: PutStringFormat.base64,
      metadata: SettableMetadata(contentType: "image/jpg"),
    );

    await _firestore
        .collection('pit_scouting')
        .doc("${newTeam.teamNo}")
        .set(await newTeam.toFirebase(await ref.getDownloadURL()));

    await _pitScoutingService.updateTeam(newTeam);
  }

  Future<List<PitScoutingTeam>> getTeams() async {
    List<PitScoutingTeam> teams = [];

    QuerySnapshot result = await _firestore.collection('pit_scouting').get();

    result.docs.forEach((teamMap) {
      var team = PitScoutingTeam.fromFirebase(teamMap.data());
      teams.add(team);
    });

    return teams;
  }

  Future<void> deleteTeam(PitScoutingTeam team) async {
    await _firestore.collection('pit_scouting').doc("${team.teamNo}").delete();
  }
}
