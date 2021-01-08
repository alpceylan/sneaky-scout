// Database
import 'package:sneakyscout/database/our_db.dart';

// Services
import 'package:sneakyscout/services/authentication_service.dart';

// Models
import 'package:sneakyscout/models/pit_scouting_team.dart';

class PitScoutingService {
  OurDatabase _ourDatabase = OurDatabase();
  AuthenticationService _authService = AuthenticationService();

  Future<int> saveTeam(PitScoutingTeam team) async {
    return await _ourDatabase.save('pitScouting', team.toLocal(""));
  }

  Future<List<PitScoutingTeam>> getTeams() async {
    List<PitScoutingTeam> teamList = [];

    var teams = await _ourDatabase.getAll('pitScouting');
    teams.forEach((teamMap) {
      var team = PitScoutingTeam.fromLocal(teamMap);
      if (team.userId == _authService.currentUser.uid) {
        teamList.add(team);
      }
    });

    return teamList;
  }

  Future<int> updateTeam(PitScoutingTeam team) async {
    return await _ourDatabase.update('pitScouting', team.toLocal(""));
  }

  Future<void> deleteTeam(int teamNo) async {
    await _ourDatabase.delete('pitScouting', teamNo);
  }
}
