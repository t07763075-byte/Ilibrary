import 'package:ELibrary/Models/book_note_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../Models/book_text_address.dart';
import 'book_db_table.dart';
import '../const.dart';
import '../database_helper.dart';

class NoteDbHelper{
  // singleton
  factory NoteDbHelper(){
    _this ??= NoteDbHelper._();
    return _this!;
  }
  static NoteDbHelper? _this;
  NoteDbHelper._();

  final db = DatabaseHelper().db;

  static String tableName = ConstDb.noteTableName;

  Future<int> insert({required BookNoteModel note}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: note.bookId)) return -1;
    return await db.insert(tableName, note.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAllNotExist({required List<BookNoteModel> notes}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: notes.firstOrNull?.bookId)) return;
    final batch = db.batch();
    for (BookNoteModel note in notes) {
      if(note.id == null) continue;
      batch.insert(tableName, note.copyWith(isSynced: true).toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  Future<int> update({required BookNoteModel note}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: note.bookId)) return -1;
    return await db.update(tableName, note.toJson(), where: '${BookNoteModel.idText} = ?', whereArgs: [note.id],);
  }
  Future<int> delete({required int id}) async {
    return await db.delete(tableName, where: '${BookNoteModel.idText} = ?', whereArgs: [id],);
  }

  Future<int> deleteByBookId({required int bookId}) async {
    return await db.delete(tableName, where: '${BookNoteModel.bookIdText} = ?', whereArgs: [bookId],);
  }

  Future<BookNoteModel?> getById({required int id}) async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: '${BookNoteModel.idText} = ?',whereArgs: [id]);
    if (maps.isEmpty) return null;
    return BookNoteModel.fromJson(maps.first);
  }

  Future<List<BookNoteModel>> getAllNotDeleted() async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: "${BookNoteModel.localActionTypeText} != ?",whereArgs: [LocalActionType.delete.index]);
    if (maps.isEmpty) return [];
    return maps.map((e) => BookNoteModel.fromJson(e)).toList();
  }

  Future<List<BookNoteModel>> getAllNotSync() async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: "${BookNoteModel.isSyncedText} = ?",whereArgs: [0]);
    if (maps.isEmpty) return [];
    return maps.map((e) => BookNoteModel.fromJson(e)).toList();
  }

  Future<bool> deleteAll() async {
    int result = await db.rawDelete("delete from $tableName");
    return result != -1;
  }
}