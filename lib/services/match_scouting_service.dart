// Database
import 'package:sneakyscout/database/our_db.dart';

// Services
import 'package:sneakyscout/services/authentication_service.dart';

// Models
import 'package:sneakyscout/models/match_scouting_team.dart';

class MatchScoutingService {
  OurDatabase _ourDatabase = OurDatabase();
  AuthenticationService _authService = AuthenticationService();

  Future<int> saveTeam(MatchScoutingTeam team) async {
    return await _ourDatabase.save('matchScouting', team.toLocal());
  }

  Future<List<MatchScoutingTeam>> getTeams() async {
    List<MatchScoutingTeam> teamList = [];

    var teams = await _ourDatabase.getAll('matchScouting');
    teams.forEach((teamMap) {
      var team = MatchScoutingTeam.fromLocal(teamMap);
      if (team.userId == _authService.currentUser.uid) {
        teamList.add(team);
      }
    });

    return teamList;
  }

  Future<int> updateTeam(MatchScoutingTeam team) async {
    return await _ourDatabase.update('matchScouting', team.toLocal());
  }

  Future<void> deleteTeam(int teamNo) async {
    await _ourDatabase.delete('matchScouting', teamNo);
  }
}
