import 'package:mvvm_sqlite_demo/dao/db.dart';
import 'package:mvvm_sqlite_demo/dao/major_dao.dart';
import 'package:sqflite/sqflite.dart';

import '../model/student.dart';

class StudentDao {
    static const TABLE_NAME = 'students';
    static const COL_ID = 'STU_ID';
    static const COL_MAJ_ID = 'MAJ_ID';
    static const COL_LASTNAME = 'LastName';
    static const COL_FIRSTNAME = 'FirstName';
    static const COL_GENDER = 'Gender';
    static const COL_PHONE = 'Phone';
    static const COL_EMAIL = 'Email';

    static String createTable() => '''
      CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $COL_MAJ_ID INTEGER,
        $COL_LASTNAME TEXT,
        $COL_FIRSTNAME TEXT,
        $COL_GENDER INTEGER,
        $COL_PHONE TEXT,
        $COL_EMAIL TEXT,
        FOREIGN KEY ($COL_MAJ_ID) REFERENCES ${MajorDao.TABLE_NAME}(${MajorDao.COL_ID})
      );
    ''';

    Future<bool> insert(Student student) async {
      final db = await DB().open();

      final result = await db.insert(
        TABLE_NAME,
        _toMap(student),
        conflictAlgorithm: ConflictAlgorithm.replace
      );

      db.close();
      return result > 0;
    }

    Future<bool> update(Student student) async {
      final db = await DB().open();

      final result = await db.update(
        TABLE_NAME,
        _toMap(student),
        where: '$COL_ID = ?',
        whereArgs: [student.id],
        conflictAlgorithm: ConflictAlgorithm.replace
      );

      db.close();
      return result > 0;
    }

    Future<bool> delete(int id) async {
      final db = await DB().open();

      final result = await db.delete(
        TABLE_NAME,
        where: '$COL_ID =?',
        whereArgs: [id],
      );

      db.close();
      return result > 0;
    }

    Future<Student?> get(int id) async {
      final db = await DB().open();

      final result = await db.query(
        TABLE_NAME,
        where: '$COL_ID = ?',
        whereArgs: [id],
        limit: 1
      );

      db.close();
      return result.isEmpty ? null : _toStudent(result[0]);
    }

    Future<List<Student>> getStudents() async {
      final db = await DB().open();

      final result = await db.query(TABLE_NAME);

      db.close();
      return List.generate(result.length, (index) => _toStudent(result[index]));
    }

    Map<String, dynamic> _toMap(Student student) {
      return {
        //COL_ID: student.id,
        COL_MAJ_ID: student.major_id,
        COL_LASTNAME: student.lastName,
        COL_FIRSTNAME: student.firstName,
        COL_GENDER: student.gender,
        COL_PHONE: student.phone,
        COL_EMAIL: student.email
      };
    }

    Student _toStudent(Map<String, dynamic> map) {
      return Student(id: map[COL_ID], major_id: map[COL_MAJ_ID], lastName: map[COL_LASTNAME], 
        firstName: map[COL_FIRSTNAME], gender: map[COL_GENDER], phone: map[COL_PHONE], email: map[COL_EMAIL]);
    }
}