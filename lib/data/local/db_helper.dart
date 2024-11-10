import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  //singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  // table note
  static const String TABLE_NOTE = "note";
  static const String COLUMN_NOTE_SNO = "s_no";
  static const String COLUMN_NOTE_TITLE = "title";
  static const String COLUMN_NOTE_DESC = "desc";

  //DB open () (path if exists then then open otherwise create)
  Database? myDB;
  Future<Database> getDB() async {
    myDB = myDB ?? await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, "noteDB.db");
    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        /// create all your tables here
        db.execute(
            "create table $TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key autoincrement,$COLUMN_NOTE_TITLE text,$COLUMN_NOTE_DESC text)");
      },
      version: 1,
    );
  }

  /// all query
  /// insertion
  Future<bool> addNote({required String title, required String desc}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: title,
      COLUMN_NOTE_DESC: desc,
    });
    return rowsEffected > 0;
  }

  /// reading all data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();

    /// select * from note
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE, columns: [
      COLUMN_NOTE_TITLE,
      COLUMN_NOTE_SNO,
      COLUMN_NOTE_DESC,
    ]);
    return mData;
  }

  ///update Data
  Future<bool> updateNote({
    required String title,
    required String desc,
    required int id,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.update(
      TABLE_NOTE,
      {
        COLUMN_NOTE_DESC: desc,
        COLUMN_NOTE_TITLE: title,
      },
      where: "$COLUMN_NOTE_SNO = $id",
    );
    return rowsEffected > 0;
  }

  ///delete Data
  Future<bool> deleteNote({
    required int id,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.delete(
      TABLE_NOTE,
      where: "$COLUMN_NOTE_SNO = ?",
      whereArgs: ['$id'],
    );
    return rowsEffected > 0;
  }
}
