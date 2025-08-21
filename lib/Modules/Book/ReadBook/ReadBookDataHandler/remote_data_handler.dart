import 'dart:async';
import 'dart:convert';
import 'package:ELibrary/Models/book_highlight_model.dart';
import 'package:ELibrary/Models/book_text_address.dart';
import 'package:ELibrary/Modules/Book/ReadBook/read_book_controller.dart';
import 'package:ELibrary/Utilities/extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import '../../../../Models/book_mark_model.dart';
import '../../../../Models/book_note_model.dart';
import '../../../../Models/definition_model.dart';
import '../../../../Utilities/api_end_point.dart';
import '../../../../Utilities/format_date_helper.dart';
import '../../../../core/API/generic_request.dart';
import '../../../../core/API/request_method.dart';
import '../../../../core/Caching/cached_books_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import 'package:http/http.dart' as http;

class ReadBookRemoteDataHandler{

  static Future<Either<Failure,List<String>>> getBookById({required int bookId,required bool disableCache})async{
    try {
      final cachedBookData = await CachedBooksHelper.getCachedBook(bookId);
      if(cachedBookData != null && !disableCache) return Right(cachedBookData);
      Uint8List response = await GenericRequest(
        fromMap: (_)=> _,
        method: RequestApi.get(url: APIEndPoint.getBookPages(bookId),),
      ).getResponseBytes();
      final result = await ReadBookController.parseHtmlInIsolate(htmlBook: utf8.decode(response));
      return Right( result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,List<BookHighlightModel>>> getHighlightsList({required int bookId})async{
    try {
      List<BookHighlightModel> response = await GenericRequest<BookHighlightModel>(
        method: RequestApi.get(url: APIEndPoint.getBookHighlights(bookId),),
        fromMap: BookHighlightModel.fromJson,
      ).getList();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,List<BookNoteModel>>> getNotesList({required int bookId})async{
    try{
      List<BookNoteModel> response = await GenericRequest<BookNoteModel>(
        method: RequestApi.get(url: APIEndPoint.getBookNotes(bookId),),
        fromMap: BookNoteModel.fromJson,
      ).getList();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, List<BookMarkModel>>> getBookMarkList({required int bookId,}) async {
    try {
      List<BookMarkModel> response = await GenericRequest<BookMarkModel>(
        method: RequestApi.postJson(url: APIEndPoint.listMarks,
          bodyJson: {
            "pageSize": 9999,
            "pageIndex": 0,
            "filter": {
              "id": bookId,
            }
          },
        ),
        fromMap: BookMarkModel.fromJson,
      ).getList();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }


  static Future<Either<Failure,BookHighlightModel>> addHighlight({required BookHighlightModel highlight})async{
    try {
      int response = await GenericRequest<int>(
        method: RequestApi.postJson(
          url: APIEndPoint.addHighLight,
          bodyJson: {
            "bookId": highlight.bookId,
            "title": highlight.title,
            "page": highlight.page,
            "color": highlight.color,
            "selection": json.encode(highlight.selection?.toJson()),
            "date": FormatDateHelper.formatterToApi.format(highlight.date ?? DateTime.now()),
          }
        ),
        fromMap: (_)=> _["data"],
      ).getResponse();
      return Right(highlight.copyWith(id: response,isSynced: true));
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure,bool>> editHighlight({required int highLightId, required String color})async{
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.putJson(
          url: APIEndPoint.updateHighLight,
          bodyJson: {
            "id": highLightId,
            "color": color,
          }
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,BookNoteModel>> addNote({required BookNoteModel noteModel,})async{
    try {
      int response = await GenericRequest<int>(
        method: RequestApi.postJson(
            url: APIEndPoint.addNote,
            bodyJson: {
              "bookId": noteModel.bookId,
              "title": noteModel.title,
              "info": noteModel.info,
              "page": noteModel.page,
              "noteIndex": noteModel.noteIndex,
              "selection": json.encode(noteModel.selection?.toJson()),
              "date": FormatDateHelper.formatterToApi.format(noteModel.date ?? DateTime.now()),
            }
        ),
        fromMap: (_)=> _["data"],
      ).getResponse();
      return Right(noteModel.copyWith(id: response,isSynced: true));
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure,bool>> editNote({required int id, required String note})async{
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.putJson(
            url: APIEndPoint.editNote,
            bodyJson: {
            "id": id,
            "info": note,
            }
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,BookMarkModel>> addBookMark({required int bookId, required int pageIndex})async{
    try {
      int response = await GenericRequest<int>(
        method: RequestApi.postJson(
            url: APIEndPoint.bookMark,
            bodyJson: {
              "bookId": bookId,
              "page": pageIndex
            }
        ),
        fromMap: (_)=> _["data"] ?? 0,
      ).getResponse();
      return Right(BookMarkModel(id: response,bookId: bookId, page: pageIndex, isSynced: true,localActionType: LocalActionType.add));
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }





  static Future<Either<Failure,String>> translate({required String selectedText, required int translateInto})async{
    try {
      String response = await GenericRequest<String>(
        method: RequestApi.postJson(
          url: APIEndPoint.translate,
          bodyJson: {
            "text": selectedText,
            "toLanguage": translateInto.toString(),
          }
        ),
        fromMap: (_)=> _["translatedText"]?["result"]?["data"],
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,String>> explain({required int bookId, required String selectedText,required int? languageId})async{
    try {
      String response = await GenericRequest<String>(
        method: RequestApi.postJson(
            url: APIEndPoint.explain,
            bodyJson: {
              "bookid": bookId,
              "text": selectedText,
              "languageId": languageId,
            }
        ),
        fromMap: (_)=> _["data"],
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,DefinitionModel>> definition({required int bookId, required String selectedText, required int? languageId})async{
    try {
      DefinitionModel response = await GenericRequest<DefinitionModel>(
        method: RequestApi.postJson(
            url: APIEndPoint.definition,
            bodyJson: {
              "bookid": bookId,
              "text": selectedText,
              "languageId": languageId,
            }
        ),
        fromMap: DefinitionModel.fromJson,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,bool>> saveDefinition({ int? definitionId,})async{
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
            url: APIEndPoint.saveDefinition(definitionId),
            bodyJson: {

            }
        ),
        fromMap: (_)=> _["success"] == true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,bool>> finishedRead({ int? bookId,})async{
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
            url: APIEndPoint.finishedRead(bookId),
            bodyJson: {}
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure,bool>> updateLastReading({required int bookId,required DateTime lastReadingTime})async{
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
          url: APIEndPoint.updateLastReadTime,
          bodyJson: {
            "bookId": bookId,
            "lastReadTime": lastReadingTime.toIso8601String()
          }
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<String?> getHtmlFromUrl({required String url}) async{
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.body;
    } catch (_) {}
    return null;
  }
}