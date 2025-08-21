import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../Models/book_model.dart';
import '../const.dart';
import '../database_helper.dart';

class BookDbHelper{
  // singleton
  factory BookDbHelper(){
    _this ??= BookDbHelper._();
    return _this!;
  }
  static BookDbHelper? _this;
  BookDbHelper._();

  final db = DatabaseHelper().db;

  static String tableName = ConstDb.bookTableName;

  static Future<bool> canUseLocalDB({int? bookId})async{
    if(kIsWeb || bookId == null) return false;
    BookModel? book = await BookDbHelper().getById(id: bookId);
    return book != null;
  }

  Future<int> insert({required BookModel book}) async {
    if(await canUseLocalDB(bookId: book.id)){
      log("can not insert book without id, you can't add new one");
      return -1;
    }
    return await db.insert(tableName, book.toJsonDB(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update({required BookModel book}) async {
    if(!await BookDbHelper.canUseLocalDB(bookId: book.id)) return -1;
    return await db.update(tableName, book.toJson(), where: '${BookModel.idText} = ?', whereArgs: [book.id],);
  }

  Future<int> delete({required int id}) async {
    return await db.delete(tableName, where: '${BookModel.idText} = ?', whereArgs: [id],);
  }

  Future<BookModel?> getById({required int id}) async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: '${BookModel.idText} = ?',whereArgs: [id]);
    if (maps.isEmpty) return null;
    return BookModel.fromJson(maps.first);
  }

  Future<List<BookModel>> getAllNotSync() async {
    List<Map<String,dynamic>> maps = await db.query(tableName,where: "${BookModel.isSyncedText} = ?",whereArgs: [0]);
    if(maps.isEmpty) return [];
    return maps.map((e) => BookModel.fromJson(e)).toList();
  }

  Future<List<BookModel>> getAll() async {
    List<Map<String,dynamic>> maps = await db.query(tableName);
    if (maps.isEmpty) return [];
    return maps.map((e) => BookModel.fromJson(e)).toList();
  }

  Future<bool> deleteAll() async {
    int result = await db.rawDelete("delete from $tableName");
    return result != -1;
  }
}