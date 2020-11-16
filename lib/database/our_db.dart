import './db_connection.dart';

import 'package:sqflite/sqflite.dart';

class OurDatabase {
  DatabaseConnection _connection = DatabaseConnection();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _connection.setDatabase();
    return _database;
  }

  Future<int> save(String table, dynamic data) async {
    Database db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getAll(String table, userId) async {
    Database db = await database;
    return await db.query(table, where: 'userId=?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getById(String table, itemId) async {
    Database db = await database;
    return await db.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  Future<int> update(String table, data) async {
    Database db = await database;
    return await db.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  Future<int> delete(String table, id) async {
    Database db = await database;
    return await db.rawDelete('DELETE FROM $table WHERE id = $id');
  }

  Future<List<Map<String, dynamic>>> getByColumnName(
      String table, String columnName, String columnValue) async {
    Database db = await database;
    return await db
        .query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }
}
