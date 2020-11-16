// Database
import '../database/our_db.dart';

// Models
import '../models/matchScoutingTeam.dart';

class MatchScoutingService {
  OurDatabase _ourDatabase = OurDatabase();

  Future<int> saveTeam(MatchScoutingTeam team) async {
    return await _ourDatabase.save('matchScouting', team.teamMap());
  }

  Future<List<Map<String, dynamic>>> getTeams() async {
    return await _ourDatabase.getAll('matchScouting');
  }

  Future<List<Map<String, dynamic>>> getTeamById(dynamic teamId) async {
    return await _ourDatabase.getById('matchScouting', teamId);
  }

  Future<int> updateTeam(MatchScoutingTeam team) async {
    return await _ourDatabase.update('matchScouting', team.teamMap());
  }

  Future<void> deleteTeam(dynamic teamId) async {
    await _ourDatabase.delete('matchScouting', teamId);
  }
}