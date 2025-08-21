import 'package:ELibrary/Models/book_highlight_model.dart';
import 'package:ELibrary/Modules/Book/ReadBook/ReadBookDataHandler/local_data_handler.dart';
import 'package:ELibrary/Modules/Book/ReadBook/ReadBookDataHandler/remote_data_handler.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/core/network/internet_connection_provider.dart';
import 'package:dartz/dartz.dart';
import '../../../../LocalDatabase/Tables/book_mark_db_table.dart';
import '../../../../LocalDatabase/Tables/highlight_db_table.dart';
import '../../../../LocalDatabase/Tables/note_db_table.dart';
import '../../../../Models/book_mark_model.dart';
import '../../../../Models/book_note_model.dart';
import '../../../../Models/definition_model.dart';
import '../../../../Utilities/general_data_handler.dart';
import '../../../../core/error/failures.dart';

class ReadBookDataHandlerManage{

  final bool isSavedLocal;
  ReadBookDataHandlerManage({required this.isSavedLocal,});

  Future<Either<Failure,List<String>>> getBookById({required int bookId})async{
    if(deviceHaveInternet){
      if(isSavedLocal) return ReadBookLocalDataHandler.getBookById(bookId: bookId);
      return await ReadBookRemoteDataHandler.getBookById(bookId: bookId, disableCache: false);
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.getBookById(bookId: bookId);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  Future<Either<Failure,List<BookHighlightModel>>> getHighlightsList({required int bookId})async{
    if(deviceHaveInternet){
      final result = await ReadBookRemoteDataHandler.getHighlightsList(bookId: bookId);
      if(!isSavedLocal || result.isLeft()) return result;
      await HighlightDbHelper().insertAllNotExist(highlights: result.getOrElse(()=> []));
      return await ReadBookLocalDataHandler.getHighlightsList(bookId: bookId);
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.getHighlightsList(bookId: bookId);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  Future<Either<Failure,List<BookNoteModel>>> getNotesList({required int bookId})async{
    if(deviceHaveInternet){
      final result = await ReadBookRemoteDataHandler.getNotesList(bookId: bookId);
      if(!isSavedLocal || result.isLeft()) return result;
      await NoteDbHelper().insertAllNotExist(notes: result.getOrElse(()=> []));
      return await ReadBookLocalDataHandler.getNotesList(bookId: bookId);
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.getNotesList(bookId: bookId);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  Future<Either<Failure, List<BookMarkModel>>> getBookMarkList({required int bookId,})async{
    if(deviceHaveInternet){
      final result = await ReadBookRemoteDataHandler.getBookMarkList(bookId: bookId,);
      if(!isSavedLocal || result.isLeft()) return result;
      await BookMarkDbHelper().insertAllNotExist(bookMarks: result.getOrElse(()=> []));
      return await ReadBookLocalDataHandler.getBookMarkList(bookId: bookId,);
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.getBookMarkList(bookId: bookId,);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }


  Future<Either<Failure,BookHighlightModel>> addHighlight({required BookHighlightModel highlight})async{
    if(deviceHaveInternet){
      final result = await ReadBookRemoteDataHandler.addHighlight(highlight: highlight);
      if(!isSavedLocal || result.isLeft()) return result;
      return await ReadBookLocalDataHandler.addHighlight(highlight: result.getOrElse(()=> BookHighlightModel(isSynced: true, localActionType: null)));
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.addHighlight(highlight: highlight);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }
  Future<Either<Failure,bool>> editHighlight({required int highLightId, required String color})async{
    if(deviceHaveInternet){
      final result = await ReadBookRemoteDataHandler.editHighlight(highLightId: highLightId, color: color);
      if(!isSavedLocal || result.isLeft()) return result;
      return await ReadBookLocalDataHandler.editHighlight(highLightId: highLightId, color: color,isSync: true);
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.editHighlight(highLightId: highLightId, color: color,isSync: false);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }
  Future<Either<Failure,bool>> deleteHighlight({required int id})async{
    if(deviceHaveInternet){
      final result = await GeneralDataHandler.deleteHighLight(highLightId: id);
      if(!isSavedLocal || result.isLeft()) return result;
      return await ReadBookLocalDataHandler.deleteHighlight(id: id,isSync: result.isRight());
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.deleteHighlight(id: id,isSync: false);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  Future<Either<Failure,BookNoteModel>> addNote({required BookNoteModel noteModel,})async{
    if(deviceHaveInternet){
      final result = await ReadBookRemoteDataHandler.addNote(noteModel: noteModel);
      if(!isSavedLocal || result.isLeft()) return result;
      return await ReadBookLocalDataHandler.addNote(noteModel: result.getOrElse(()=> BookNoteModel(localActionType: null, isSynced: true)));
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.addNote(noteModel: noteModel);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }
  Future<Either<Failure,bool>> editNote({required int id, required String note})async{
    if(deviceHaveInternet){
      final result = await ReadBookRemoteDataHandler.editNote(id: id,note: note,);
      if(!isSavedLocal || result.isLeft()) return result;
      return await ReadBookLocalDataHandler.editNote(id: id,note: note,isSync: result.isRight());
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.editNote(id: id,note: note,isSync: false);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }
  Future<Either<Failure,bool>> deleteNote({required int id})async{
    if(deviceHaveInternet){
      final result = await GeneralDataHandler.deleteNote(noteId: id);
      if(!isSavedLocal || result.isLeft()) return result;
      return await ReadBookLocalDataHandler.deleteNote(id: id,isSync: result.isRight());
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.deleteNote(id: id,isSync: false);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  Future<Either<Failure,BookMarkModel>> addBookMark({required int bookId, required int pageIndex})async{
    if(deviceHaveInternet){
      final result = await ReadBookRemoteDataHandler.addBookMark(bookId: bookId,pageIndex: pageIndex);
      if(!isSavedLocal || result.isLeft()) return result;
      return await ReadBookLocalDataHandler.addBookMark(id: result.getOrElse(()=> BookMarkModel(localActionType: null)).id,bookId: bookId,pageIndex: pageIndex,isSync: result.isRight());
    }else{
      if(isSavedLocal) return  await ReadBookLocalDataHandler.addBookMark(bookId: bookId,pageIndex: pageIndex,isSync: false);
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }




  static Future<Either<Failure,String>> translate({required String selectedText, required int translateInto})async {
    if(deviceHaveInternet){
      return await ReadBookRemoteDataHandler.translate(selectedText: selectedText, translateInto: translateInto);
    }else{
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  static Future<Either<Failure,String>> explain({required int bookId, required String selectedText,required int? languageId}) async{
    if(deviceHaveInternet){
      return await ReadBookRemoteDataHandler.explain(selectedText: selectedText,bookId: bookId,languageId: languageId);
    }else{
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  static Future<Either<Failure,DefinitionModel>> definition({required int bookId, required String selectedText, required int? languageId}) async{
    if(deviceHaveInternet){
      return await ReadBookRemoteDataHandler.definition(selectedText: selectedText,bookId: bookId,languageId: languageId);
    }else{
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  static Future<Either<Failure,bool>> saveDefinition({int? definitionId,}) async{
    if(deviceHaveInternet){
      return await ReadBookRemoteDataHandler.saveDefinition(definitionId: definitionId);
    }else{
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  static Future<Either<Failure,bool>> finishedRead({int? bookId,}) async{
    if(deviceHaveInternet){
      return await ReadBookRemoteDataHandler.finishedRead(bookId: bookId);
    }else{
      return Left(ConnectionError(Strings.noInternetConnection.tr));
    }
  }

  static Future<String?> getHtmlFromUrl({required String url}) async{
    if(!deviceHaveInternet) return null;
    return await ReadBookRemoteDataHandler.getHtmlFromUrl(url: url);
  }
}