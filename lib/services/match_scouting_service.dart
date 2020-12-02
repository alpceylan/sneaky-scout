// Database
import '../database/our_db.dart';

// Services
import './authentication_service.dart';

// Models
import '../models/match_scouting_team.dart';

class MatchScoutingService {
  OurDatabase _ourDatabase = OurDatabase();
  AuthenticationService _authService = AuthenticationService();

  Future<int> saveTeam(MatchScoutingTeam team) async {
    return await _ourDatabase.save('matchScouting', await team.mapTeam(false));
  }

  Future<List<MatchScoutingTeam>> getTeams() async {
    List<MatchScoutingTeam> teamList = [];

    var teams = await _ourDatabase.getAll('matchScouting');
    teams.forEach((teamMap) {
      var team = MatchScoutingTeam().unmapTeam(teamMap, false);
      if (team.userId == _authService.currentUser.uid) {
        teamList.add(team);
      }
    });

    return teamList;
  }

  Future<List<Map<String, dynamic>>> getTeamById(dynamic teamId) async {
    return await _ourDatabase.getById('matchScouting', teamId);
  }

  Future<int> updateTeam(MatchScoutingTeam team) async {
    return await _ourDatabase.update(
        'matchScouting', await team.mapTeam(false));
  }

  Future<void> deleteTeam(dynamic teamId) async {
    await _ourDatabase.delete('matchScouting', teamId);
  }
}
