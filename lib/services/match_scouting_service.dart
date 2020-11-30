// Database
import '../database/our_db.dart';

// Models
import '../models/match_scouting_team.dart';

class MatchScoutingService {
  OurDatabase _ourDatabase = OurDatabase();

  Future<int> saveTeam(MatchScoutingTeam team) async {
    return await _ourDatabase.save('matchScouting', await team.mapTeam());
  }

  Future<List<Map<String, dynamic>>> getTeams() async {
    return await _ourDatabase.getAll('matchScouting');
  }

  Future<List<Map<String, dynamic>>> getTeamById(dynamic teamId) async {
    return await _ourDatabase.getById('matchScouting', teamId);
  }

  Future<int> updateTeam(MatchScoutingTeam team) async {
    return await _ourDatabase.update('matchScouting', await team.mapTeam());
  }

  Future<void> deleteTeam(dynamic teamId) async {
    await _ourDatabase.delete('matchScouting', teamId);
  }
}
