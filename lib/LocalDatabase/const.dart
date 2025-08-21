
import 'package:ELibrary/Models/book_model.dart';

import '../Models/book_highlight_model.dart';
import '../Models/book_mark_model.dart';
import '../Models/book_note_model.dart';

class ConstDb {
  static const String dbName = "elibrary.db";

  static const String bookTableName = "book";
  static const String highlightTableName = "highlight";
  static const String noteTableName = "note";
  static const String bookMarkTableName = "bookMark";



  static String createHighlightTable =
  """CREATE TABLE IF NOT EXISTS $highlightTableName (
    ${BookHighlightModel.idText} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    ${BookHighlightModel.bookIdText} INTEGER, 
    ${BookHighlightModel.titleText} TEXT, 
    ${BookHighlightModel.pageText} INTEGER, 
    ${BookHighlightModel.dateText} TEXT, 
    ${BookHighlightModel.colorText} TEXT, 
    ${BookHighlightModel.selectionText} TEXT,
    ${BookHighlightModel.isSyncedText} INTEGER,
    ${BookHighlightModel.localActionTypeText} INTEGER
  )""";

  static String createNoteTable =
  """CREATE TABLE IF NOT EXISTS $noteTableName (
    ${BookNoteModel.idText} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    ${BookNoteModel.noteIndexText} INTEGER, 
    ${BookNoteModel.userIdText} INTEGER, 
    ${BookNoteModel.bookIdText} INTEGER, 
    ${BookNoteModel.bookTitleText} TEXT, 
    ${BookNoteModel.titleText} TEXT, 
    ${BookNoteModel.infoText} TEXT, 
    ${BookNoteModel.pageText} INTEGER, 
    ${BookNoteModel.dateText} TEXT, 
    ${BookNoteModel.selectionText} TEXT,
    ${BookNoteModel.isSyncedText} INTEGER,
    ${BookNoteModel.localActionTypeText} INTEGER
  )""";

  static String createBookTable =
  """CREATE TABLE IF NOT EXISTS $bookTableName (
    ${BookModel.idText} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    ${BookModel.titleText} TEXT, 
    ${BookModel.imageUrlText} TEXT, 
    ${BookModel.pageCountText} TEXT, 
    ${BookModel.downloadCountText} INTEGER, 
    ${BookModel.totalRatingCountText} INTEGER, 
    ${BookModel.isSyncedText} INTEGER, 
    ${BookModel.lastReadingTimeText} INTEGER, 
    ${BookModel.totalRatingText} REAL
  )""";

  static String createBookMarkTable = """
  CREATE TABLE IF NOT EXISTS $bookMarkTableName (
    ${BookMarkModel.idText} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ${BookMarkModel.bookIdText} INTEGER,
    ${BookMarkModel.pageText} INTEGER,
    ${BookMarkModel.titleText} TEXT,
    ${BookMarkModel.totalRatingText} REAL,
    ${BookMarkModel.imageUrlText} TEXT,
    ${BookMarkModel.isSyncedText} INTEGER,
    ${BookMarkModel.localActionTypeText} INTEGER
  )
""";

}
