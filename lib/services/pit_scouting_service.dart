// Database
import '../database/our_db.dart';

// Services
import './authentication_service.dart';

// Models
import '../models/pit_scouting_team.dart';

class PitScoutingService {
  OurDatabase _ourDatabase = OurDatabase();
  AuthenticationService _authService = AuthenticationService();

  Future<int> saveTeam(PitScoutingTeam team) async {
    return await _ourDatabase.save(
        'pitScouting', await team.mapTeam(false, ""));
  }

  Future<List<PitScoutingTeam>> getTeams() async {
    List<PitScoutingTeam> teamList = [];

    var teams = await _ourDatabase.getAll('pitScouting');
    teams.forEach((teamMap) {
      var team = PitScoutingTeam().unmapTeam(teamMap, false);
      if (team.userId == _authService.currentUser.uid) {
        teamList.add(team);
      }
    });

    return teamList;
  }

  Future<int> updateTeam(PitScoutingTeam team) async {
    return await _ourDatabase.update(
        'pitScouting', await team.mapTeam(false, ""));
  }

  Future<void> deleteTeam(int teamNo) async {
    await _ourDatabase.delete('pitScouting', teamNo);
  }
}
