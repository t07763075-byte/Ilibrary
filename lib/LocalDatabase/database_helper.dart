import 'package:ELibrary/LocalDatabase/Tables/book_db_table.dart';
import 'package:ELibrary/LocalDatabase/Tables/highlight_db_table.dart';
import 'package:ELibrary/LocalDatabase/Tables/note_db_table.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'Tables/book_mark_db_table.dart';
import 'const.dart';
import 'local_db_helper.dart';

class DatabaseHelper {
  // singleton
  factory DatabaseHelper() => _this ??= DatabaseHelper._();
  static DatabaseHelper? _this;
  DatabaseHelper._();

  late Database db;

  Future<Database> init({bool isIsolate = false})async {
    if(isIsolate){
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final folderPath = await LocalDBHelper.getLocalFolderPath();
    db = await databaseFactory.openDatabase(
      join(folderPath, ConstDb.dbName),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(ConstDb.createBookTable);
          await db.execute(ConstDb.createHighlightTable);
          await db.execute(ConstDb.createNoteTable);
          await db.execute(ConstDb.createBookMarkTable);
        },
      ),
    );
    return db;
  }

  Future deleteDataBase() async {
    final folderPath = await LocalDBHelper.getLocalFolderPath();
    await deleteDatabase(join(folderPath, ConstDb.dbName));
  }

  Future clearDataBase() async{
    await BookDbHelper().deleteAll();
    await HighlightDbHelper().deleteAll();
    await NoteDbHelper().deleteAll();
    await BookMarkDbHelper().deleteAll();
  }

}
