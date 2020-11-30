import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'db_sneakyscout');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreatingDatabase,
    );
    return database;
  }

  Future<void> _onCreatingDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE matchScouting(id INTEGER PRIMARY KEY, status TEXT, userId TEXT, scoutName TEXT, teamName TEXT, teamNo INTEGER, matchType TEXT, matchNo TEXT, color TEXT, powerCellCount INTEGER, powerCellLocation TEXT, autonomous BOOL, autonomousStartingPoint TEXT, comment TEXT, defense BOOL, defenseComment TEXT, foul INTEGER, techFoul INTEGER, imageProcessing BOOL, finalScore INTEGER)',
    );
    await db.execute(
      'CREATE TABLE pitScouting(id INTEGER PRIMARY KEY, status TEXT, userId TEXT, scoutName TEXT, teamName TEXT, teamNo INTEGER, imageUrl TEXT, imageString TEXT, chassisType TEXT, climbing BOOL, climbingComment TEXT, imageProcessing BOOL, imageProcessingType TEXT, shooterType TEXT, hoodType TEXT, intake BOOL, intakeType TEXT, funnelType TEXT, maxBalls INTEGER, autonomous BOOL, autonomousComment TEXT, extra TEXT, comment TEXT)',
    );
  }
}
