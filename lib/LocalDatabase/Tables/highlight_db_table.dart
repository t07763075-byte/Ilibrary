import 'package:ELibrary/LocalDatabase/Tables/book_db_table.dart';
import 'package:ELibrary/Models/book_text_address.dart';
import 'package:sqflite/sqflite.dart';
import '../../Models/book_highlight_model.dart';
import '../const.dart';
import '../database_helper.dart';

class HighlightDbHelper{
  // singleton
  factory HighlightDbHelper(){
    _this ??= HighlightDbHelper._();
    return _this!;
  }
  static HighlightDbHelper? _this;
  HighlightDbHelper._();

  final db = DatabaseHelper().db;

  static String tableName = ConstDb.highlightTableName;

  Future<int> insert({required BookHighlightModel highlight}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: highlight.bookId)) return -1;
    return await db.insert(tableName, highlight.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAllNotExist({required List<BookHighlightModel> highlights}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: highlights.firstOrNull?.bookId)) return;
    final batch = db.batch();
    for (BookHighlightModel highlight in highlights) {
      if(highlight.id == null) continue;
      batch.insert(tableName, highlight.copyWith(isSynced: true).toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  Future<int> update({required BookHighlightModel highlight}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: highlight.bookId)) return -1;
    return await db.update(tableName, highlight.toJson(), where: '${BookHighlightModel.idText} = ?', whereArgs: [highlight.id],);
  }

  Future<int> delete({required int id}) async {
    return await db.delete(tableName, where: '${BookHighlightModel.idText} = ?', whereArgs: [id],);
  }

  Future<int> deleteByBookId({required int bookId}) async {
    return await db.delete(tableName, where: '${BookHighlightModel.bookIdText} = ?', whereArgs: [bookId],);
  }

  Future<BookHighlightModel?> getById({required int id}) async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: '${BookHighlightModel.idText} = ?',whereArgs: [id]);
    if(maps.isEmpty) return null;
    return BookHighlightModel.fromJson(maps.first);
  }

  Future<List<BookHighlightModel>> getAllNotDeleted() async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: "${BookHighlightModel.localActionTypeText} != ?",whereArgs: [LocalActionType.delete.index]);
    if(maps.isEmpty) return [];
    return maps.map((e) => BookHighlightModel.fromJson(e)).toList();
  }

  Future<List<BookHighlightModel>> getAllNotSync() async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: "${BookHighlightModel.isSyncedText} = ?",whereArgs: [0]);
    if(maps.isEmpty) return [];
    return maps.map((e) => BookHighlightModel.fromJson(e)).toList();
  }

  Future<bool> deleteAll() async {
    int result = await db.rawDelete("delete from $tableName");
    return result !=- 1;
  }
}