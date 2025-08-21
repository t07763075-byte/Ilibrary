import 'dart:developer';

import 'package:ELibrary/Models/language_model.dart';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import 'package:universal_html/html.dart';

import '../Models/book_model.dart';
import '../Models/user_model.dart';
import '../core/API/generic_request.dart';
import '../core/API/request_method.dart';
import '../core/error/exceptions.dart';
import '../core/error/failures.dart';
import 'api_end_point.dart';
import 'git_it.dart';

class GeneralDataHandler {
  static init() async {
    await getToken();
    if (!GitIt.instance.isRegistered<List<LanguageModel>>()) {
      final report = await getLanguage();
      report.fold((l) => null, (r) {
        GitIt.instance.registerFactory<List<LanguageModel>>(() => r);
      });
    }
  }
  static Future getToken() async {
    String? url = window.location.href ?? '';
    if (!url.contains("token=")) return;
    String token = url.split('token=').last.split('&').first;
    // String failUrl = url.split('fail_url=').last.split('&').first;
    await SharedPref.saveCurrentUser(user: UserModel( token:token));
  }
  static Future<Either<Failure, List<LanguageModel>>> getLanguage() async {
    try {
      List<LanguageModel> response = await GenericRequest<LanguageModel>(
        method: RequestApi.postJson(url: APIEndPoint.languages, bodyJson: {}),
        fromMap: LanguageModel.fromJson,
      ).getList();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> addToWishlist({int? bookId}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
            url: APIEndPoint.addToWishlist, bodyJson: {"bookId": bookId}),
        fromMap: (_) => true,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> deleteFromWishlist({int? bookId}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.delete(
          url: APIEndPoint.deleteToWishlist(bookId),
        ),
        fromMap: (_) => true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> deleteDefinitions(
      {int? definitionsId}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.delete(
          url: APIEndPoint.deleteDefinitions(definitionsId),
        ),
        fromMap: (_) => _["success"] == true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> deleteNote({required int noteId}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.delete(
          url: APIEndPoint.deleteBookNote(noteId),
        ),
        fromMap: (_) => _["success"] == true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> deleteHighLight(
      {required int highLightId}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.delete(
          url: APIEndPoint.deleteBookHighlight(highLightId),
        ),
        fromMap: (_) => _["success"] == true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> deleteBookMark(
      {required int bookMarkId}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.delete(
          url: APIEndPoint.deleteBookMark(bookMarkId),
        ),
        fromMap: (_) => _["success"] == true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> addRating({
    double? rating,
    String? describe,
    int? bookId,
  }) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(url: APIEndPoint.rating, bodyJson: {
          "objectTypeId": 1,
          "objectId": bookId,
          "review": describe,
          "rating": rating?.toInt()
        }),
        fromMap: (_) => true,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure,BookModel>> getBookDetails({String?bookId})async{
    try {
      BookModel response = await GenericRequest<BookModel>(
        method: RequestApi.get(url: APIEndPoint.bookDetails(bookId)),
        fromMap: BookModel.fromJson,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
