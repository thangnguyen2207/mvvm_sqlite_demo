import 'package:mvvm_sqlite_demo/dao/db.dart';
import 'package:mvvm_sqlite_demo/model/major.dart';
import 'package:sqflite/sqflite.dart';

class MajorDao {
  static const TABLE_NAME = 'majors';
  static const COL_ID = 'MAJ_ID';
  static const COL_NAME = 'Name';

  static String createTable() => '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $COL_NAME TEXT
    );
  ''';

  Future<bool> insert(Major major) async {
    final db = await DB().open();

    final result = await db.insert(
      TABLE_NAME, 
      _toMap(major), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    db.close();
    return result > 0;
  }

  Future<bool> update(Major major) async {
    final db = await DB().open();

    final result = await db.update(
      TABLE_NAME, 
      _toMap(major),
      where: '$COL_ID = ?',
      whereArgs: [major.id], 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    db.close();
    return result > 0;
  }

  Future<bool> delete(int id) async {
    final db = await DB().open();

    final result = await db.delete(
      TABLE_NAME, 
      where: '$COL_ID = ?',
      whereArgs: [id],
    );
    db.close();
    return result > 0;
  }

  Future<Major?> get(int id) async {
    final db = await DB().open();

    final result = await db.query(
      TABLE_NAME, 
      where: '$COL_ID = ?',
      whereArgs: [id],
      limit: 1
    );
    db.close();
    return result.isEmpty ? null : _toMajor(result[0]);
  }

  Future<List<Major>> getMajors() async {
    final db = await DB().open();

    final result = await db.query(TABLE_NAME);
    db.close();
    return List.generate(result.length, (index) => _toMajor(result[index]));
  }

  Map<String, dynamic> _toMap(Major major) {
    return {
      //COL_ID: major.id,
      COL_NAME: major.name,
    };
  }

  Major _toMajor(Map<String, dynamic> map) {
    return Major(id: map[COL_ID], name: map[COL_NAME]);
  }
}