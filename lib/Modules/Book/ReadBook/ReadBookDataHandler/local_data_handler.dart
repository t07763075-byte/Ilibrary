import 'package:ELibrary/LocalDatabase/Tables/book_mark_db_table.dart';
import 'package:ELibrary/LocalDatabase/book_storage_service.dart';
import 'package:ELibrary/LocalDatabase/Tables/highlight_db_table.dart';
import 'package:ELibrary/LocalDatabase/Tables/note_db_table.dart';
import 'package:ELibrary/Models/book_highlight_model.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:dartz/dartz.dart';
import '../../../../Models/book_mark_model.dart';
import '../../../../Models/book_note_model.dart';
import '../../../../Models/book_text_address.dart';
import '../../../../core/error/failures.dart';

class ReadBookLocalDataHandler{

  static Future<Either<Failure,List<String>>> getBookById({required int bookId})async{
    try {
      List<String>? savedBook = await BookStorageService.getSavedBook(bookId: bookId);
      if(savedBook != null) return Right(savedBook);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }


  static Future<Either<Failure,List<BookHighlightModel>>> getHighlightsList({required int bookId})async{
    try {
      return Right(await HighlightDbHelper().getAllNotDeleted());
    }catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }

  static Future<Either<Failure,List<BookNoteModel>>> getNotesList({required int bookId})async{
    try{
     return Right(await NoteDbHelper().getAllNotDeleted());
    }catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }

  static Future<Either<Failure, List<BookMarkModel>>> getBookMarkList({required int bookId,}) async {
    try {
      return Right(await BookMarkDbHelper().getAllNotDeleted());
    }catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }


  static Future<Either<Failure,BookHighlightModel>> addHighlight({required BookHighlightModel highlight})async{
    try {
      await HighlightDbHelper().insert(highlight: highlight);
      return Right(highlight);

    } catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }
  static Future<Either<Failure,bool>> editHighlight({required int highLightId, required String color, required bool isSync})async{
    try {
      final BookHighlightModel? highlightModel = await HighlightDbHelper().getById(id: highLightId);
      await HighlightDbHelper().update(highlight: highlightModel!.copyWith(color: color,isSynced: isSync));
      return const Right(true);

    } catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }
  static Future<Either<Failure,bool>> deleteHighlight({required int id, required bool isSync})async{
    try {
      final BookHighlightModel? highlightModel = await HighlightDbHelper().getById(id: id);
      await HighlightDbHelper().update(highlight: highlightModel!.copyWith(isSynced: isSync,localActionType: LocalActionType.delete));
      return const Right(true);
    }catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }

  static Future<Either<Failure,BookNoteModel>> addNote({required BookNoteModel noteModel,})async{
    try {
      await NoteDbHelper().insert(note: noteModel);
      return Right(noteModel);
    } catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }
  static Future<Either<Failure,bool>> editNote({required int id, required String note, required bool isSync})async{
    try {
      final BookNoteModel? noteModel = await NoteDbHelper().getById(id: id);
      await NoteDbHelper().update(note: noteModel!.copyWith(info: note,isSynced: isSync));
      return const Right(true);
    }catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }

  static Future<Either<Failure,bool>> deleteNote({required int id, required bool isSync})async{
    try {
      final BookNoteModel? noteModel = await NoteDbHelper().getById(id: id);
      await NoteDbHelper().update(note: noteModel!.copyWith(isSynced: isSync,localActionType: LocalActionType.delete));
      return const Right(true);
    }catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }

  static Future<Either<Failure,BookMarkModel>> addBookMark({int? id, required int bookId, required int pageIndex, required bool isSync})async{
    try {
      BookMarkModel bookMarkModel = BookMarkModel(
        id: id,
        bookId: bookId,
        isSynced: isSync,
        localActionType: LocalActionType.add,
        page: pageIndex,
      );
      await BookMarkDbHelper().insert(bookMark: bookMarkModel,);
      return Right(bookMarkModel);
    } catch (failure) {
      return Left(LocalDBError(failure.toString()));
    }
  }

}