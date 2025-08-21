import 'package:sqflite/sqflite.dart';
import '../../Models/book_mark_model.dart';
import '../../Models/book_text_address.dart';
import 'book_db_table.dart';
import '../const.dart';
import '../database_helper.dart';

class BookMarkDbHelper{
  // singleton
  factory BookMarkDbHelper(){
    _this ??= BookMarkDbHelper._();
    return _this!;
  }
  static BookMarkDbHelper? _this;
  BookMarkDbHelper._();

  final db = DatabaseHelper().db;

  static String tableName = ConstDb.bookMarkTableName;

  Future<int> insert({required BookMarkModel bookMark}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: bookMark.bookId)) return -1;
    return await db.insert(tableName, bookMark.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertAllNotExist({required List<BookMarkModel> bookMarks}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: bookMarks.firstOrNull?.bookId)) return;
    final batch = db.batch();
    for (BookMarkModel bookMark in bookMarks) {
      if(bookMark.id == null) continue;
      batch.insert(tableName, bookMark.copyWith(isSynced: true).toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  Future<int> update({required BookMarkModel bookMark}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: bookMark.bookId)) return -1;
    return await db.update(tableName, bookMark.toJson(), where: '${BookMarkModel.idText} = ?', whereArgs: [bookMark.id],);
  }
  Future<int> delete({required int id}) async {
    return await db.delete(tableName, where: '${BookMarkModel.idText} = ?', whereArgs: [id],);
  }

  Future<int> deleteByBookId({required int bookId}) async {
    return await db.delete(tableName, where: '${BookMarkModel.bookIdText} = ?', whereArgs: [bookId],);
  }

  Future<BookMarkModel?> getById({required int id}) async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: '${BookMarkModel.idText} = ?',whereArgs: [id]);
    if (maps.isEmpty) return null;
    return BookMarkModel.fromJson(maps.first);
  }

  Future<List<BookMarkModel>> getAllNotDeleted() async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: "${BookMarkModel.localActionTypeText} != ?",whereArgs: [LocalActionType.delete.index]);
    if (maps.isEmpty) return [];
    return maps.map((e) => BookMarkModel.fromJson(e)).toList();
  }

  Future<List<BookMarkModel>> getAllNotSync() async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: "${BookMarkModel.isSyncedText} = ?",whereArgs: [0]);
    if (maps.isEmpty) return [];
    return maps.map((e) => BookMarkModel.fromJson(e)).toList();
  }

  Future<bool> deleteAll() async {
    int result = await db.rawDelete("delete from $tableName");
    return result != -1;
  }
}