import 'dart:async';
import 'dart:developer';
import 'package:ELibrary/LocalDatabase/Tables/book_db_table.dart';
import 'package:ELibrary/LocalDatabase/Tables/book_mark_db_table.dart';
import 'package:ELibrary/Models/book_mark_model.dart';
import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Utilities/git_it.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:ELibrary/LocalDatabase/Tables/note_db_table.dart';
import 'package:ELibrary/Models/book_highlight_model.dart';
import 'package:ELibrary/Models/book_note_model.dart';
import 'package:ELibrary/Modules/Book/ReadBook/ReadBookDataHandler/remote_data_handler.dart';
import 'package:ELibrary/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../Models/book_text_address.dart';
import '../Utilities/general_data_handler.dart';
import 'database_helper.dart';
import 'Tables/highlight_db_table.dart';

class SyncLocalDBService {
  static FlutterIsolate? syncAllIsolate;

  static void startSync() async{
    if(syncAllIsolate != null){
      syncAllIsolate?.resume();
    }else{
      syncAllIsolate = await FlutterIsolate.spawn(startSyncAll, "NO_PARAM");
    }
  }

  static void stopSync() {
    syncAllIsolate?.pause();
    FlutterIsolate.killAll();
    syncAllIsolate = null;
  }


  @pragma('vm:entry-point')
  static Future<void> startSyncAll(String arg) async {
    log("COMING FROM ISOLATE : startSyncAll");
    await GitIt.initGitIt();
    await DatabaseHelper().init(isIsolate: true);
    while (true) {

      // >>>>>>>>>>>>>>>>> start sync all Last Reading <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      List<BookModel> books = await BookDbHelper().getAllNotSync();
      log("COMING FROM ISOLATE : books last reading length = ${books.length}");
      for (BookModel book in books) {
        bool result = await _updateLastReadingChange(book: book);
        if(!result) continue;
        await BookDbHelper().update(book: book.copyWith(isSynced: true));
      }
      // >>>>>>>>>>>>>>>>> end sync all Last Reading <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


      // >>>>>>>>>>>>>>>>> start sync all Highlights <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      List<BookHighlightModel> localHighlights = await HighlightDbHelper().getAllNotSync();
      log("COMING FROM ISOLATE : highlight length = ${localHighlights.length}");
      for (BookHighlightModel highlight in localHighlights) {
        int result = await _updateHighlightChange(highlight: highlight);
        if(result == -1) continue;
        if (highlight.localActionType == LocalActionType.add && result > 0) {
          await HighlightDbHelper().delete(id: highlight.id!);
          await HighlightDbHelper().insert(highlight: highlight.copyWith(isSynced: true,id: result));
        }
        if (highlight.localActionType == LocalActionType.delete) await HighlightDbHelper().delete(id: highlight.id!);
        if (highlight.localActionType != LocalActionType.edit) await HighlightDbHelper().update(highlight: highlight.copyWith(isSynced: true));
      }
      // >>>>>>>>>>>>>>>>> end sync all Highlights <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




      // >>>>>>>>>>>>>>>>> start sync all notes <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      List<BookNoteModel> localNotes = await NoteDbHelper().getAllNotSync();
      log("COMING FROM ISOLATE : notes length = ${localNotes.length}");
      for (BookNoteModel note in localNotes) {
        int result = await _updateNoteChange(note: note);
        if(result == -1) continue;
        if (note.localActionType == LocalActionType.add && result > 0) {
          await NoteDbHelper().delete(id: note.id!);
          await NoteDbHelper().insert(note: note.copyWith(isSynced: true,id: result));
        }
        if (note.localActionType == LocalActionType.delete) await NoteDbHelper().delete(id: note.id!);
        if (note.localActionType != LocalActionType.edit) await NoteDbHelper().update(note: note.copyWith(isSynced: true));
      }
      // >>>>>>>>>>>>>>>>> end sync all notes <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




      // >>>>>>>>>>>>>>>>> start sync all bookMarks <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      List<BookMarkModel> localBookMarks = await BookMarkDbHelper().getAllNotSync();
      log("COMING FROM ISOLATE : BookMarks length = ${localBookMarks.length}");
      for (BookMarkModel bookMark in localBookMarks) {
        int result = await _updateBookMarkChange(bookMark: bookMark);
        if(result == -1) continue;
        if (bookMark.localActionType == LocalActionType.add && result > 0) {
          await BookMarkDbHelper().delete(id: bookMark.id!);
          await BookMarkDbHelper().insert(bookMark: bookMark.copyWith(isSynced: true,id: result));
        }
        if (bookMark.localActionType == LocalActionType.delete) await BookMarkDbHelper().delete(id: bookMark.id!);
      }
      // >>>>>>>>>>>>>>>>> end sync all bookMarks <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



      await Future.delayed(const Duration(minutes: 1));
    }
  }







  static Future<int> _updateHighlightChange({required BookHighlightModel highlight}) async {
    // return types
    // 0 : done
    // -1 : error
    // other : success with new id

    if (highlight.localActionType == null || highlight.isSynced) return -1;
    if(highlight.localActionType == LocalActionType.add){
      Either<Failure, BookHighlightModel> result = await ReadBookRemoteDataHandler.addHighlight(highlight: highlight);
      if(result.isRight()) return result.getOrElse(()=> BookHighlightModel(localActionType: null)).id!;
    }
    if(highlight.localActionType == LocalActionType.edit){
      await ReadBookRemoteDataHandler.editHighlight(highLightId: highlight.id!, color: highlight.color!);
      return 0;
    }
    if(highlight.localActionType == LocalActionType.delete){
      await GeneralDataHandler.deleteHighLight(highLightId: highlight.id!);
      return 0;
    }
    return -1;
  }

  static Future<int> _updateNoteChange({required BookNoteModel note}) async {
    // return types
    // 0 : done
    // -1 : error
    // other : success with new id

    if (note.localActionType == null || note.isSynced) return -1;
    if(note.localActionType == LocalActionType.add){
      Either<Failure, BookNoteModel> result = await ReadBookRemoteDataHandler.addNote(noteModel: note);
      if(result.isRight()) return result.getOrElse(()=> BookNoteModel(localActionType: null)).id!;
    }
    if(note.localActionType == LocalActionType.edit){
      await ReadBookRemoteDataHandler.editNote(id: note.id!, note: note.info!);
      return 0;
    }
    if(note.localActionType == LocalActionType.delete){
      await GeneralDataHandler.deleteNote(noteId: note.id!);
      return 0;
    }
    return -1;
  }

  static Future<int> _updateBookMarkChange({required BookMarkModel bookMark}) async {
    // return types
    // 0 : done
    // -1 : error
    // other : success with new id

    if (bookMark.localActionType == null || bookMark.isSynced) return -1;
    if(bookMark.localActionType == LocalActionType.add){
      Either<Failure, BookMarkModel> result = await ReadBookRemoteDataHandler.addBookMark(bookId: bookMark.bookId!,pageIndex: bookMark.page!);
      if(result.isRight()) return result.getOrElse(()=> BookMarkModel(localActionType: null)).id!;
    }
    if(bookMark.localActionType == LocalActionType.delete){
      Either<Failure, bool> result = await GeneralDataHandler.deleteBookMark(bookMarkId: bookMark.id!);
      if(result.isRight()) return 0;
    }
    return -1;
  }

  static Future<bool> _updateLastReadingChange({required BookModel book}) async {
    if (book.isSynced) return false;
    final result = await ReadBookRemoteDataHandler.updateLastReading(bookId: book.id!,lastReadingTime: book.lastReadingTime!);
    return result.isRight();
  }
}