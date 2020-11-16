// Database
import '../database/our_db.dart';

// Models
import '../models/pitScoutingTeam.dart';

class PitScoutingService {
  OurDatabase _ourDatabase = OurDatabase();

  Future<int> saveTeam(PitScoutingTeam team) async {
    return await _ourDatabase.save('pitScouting', team.teamMap());
  }

  Future<List<Map<String, dynamic>>> getTeams() async {
    return await _ourDatabase.getAll('pitScouting');
  }

  Future<List<Map<String, dynamic>>> getTeamById(dynamic teamId) async {
    return await _ourDatabase.getById('pitScouting', teamId);
  }

  Future<int> updateTeam(PitScoutingTeam team) async {
    return await _ourDatabase.update('pitScouting', team.teamMap());
  }

  Future<void> deleteTeam(dynamic teamId) async {
    await _ourDatabase.delete('pitScouting', teamId);
  }
}
