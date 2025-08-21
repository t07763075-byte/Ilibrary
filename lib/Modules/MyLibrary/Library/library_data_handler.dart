import 'package:dartz/dartz.dart';

import '../../../Models/book_model.dart';
import '../../../Models/book_note_model.dart';
import '../../../Models/definition_model.dart';
import '../../../Models/generic_pagination_model.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class LibraryDataHandler{
  static Future<Either<Failure, GenericPaginationModel<BookModel>>> getMyReads({
    required GenericPaginationModel oldPagination,
  }) async {
    try {
      GenericPaginationModel<BookModel> response =
      await GenericRequest<GenericPaginationModel<BookModel>>(
        method: RequestApi.postJson(url: APIEndPoint.myReads, bodyJson: {
          ...oldPagination.nextData,
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: BookModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure, GenericPaginationModel<BookModel>>> getWishlist({
    required GenericPaginationModel oldPagination,
  }) async {
    try {
      GenericPaginationModel<BookModel> response =
      await GenericRequest<GenericPaginationModel<BookModel>>(
        method: RequestApi.postJson(url: APIEndPoint.wishlist, bodyJson: {
          ...oldPagination.nextData,
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: BookModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure, GenericPaginationModel<BookModel>>> getHighlights({
    required GenericPaginationModel oldPagination,
  }) async {
    try {
      GenericPaginationModel<BookModel> response =
      await GenericRequest<GenericPaginationModel<BookModel>>(
        method: RequestApi.postJson(url: APIEndPoint.listHighlights,
            bodyJson: {
          ...oldPagination.nextData,
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: BookModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure, GenericPaginationModel<BookModel>>> getListMarks({
    required GenericPaginationModel oldPagination,
  }) async {
    try {
      GenericPaginationModel<BookModel> response =
      await GenericRequest<GenericPaginationModel<BookModel>>(
        method: RequestApi.postJson(url: APIEndPoint.listMarks,
            bodyJson: {
          ...oldPagination.nextData,
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: BookModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure, GenericPaginationModel<BookNoteModel>>> getUserNotes({
    required GenericPaginationModel oldPagination,
  }) async {
    try {
      GenericPaginationModel<BookNoteModel> response =
      await GenericRequest<GenericPaginationModel<BookNoteModel>>(
        method: RequestApi.postJson(url: APIEndPoint.listUserNotes,
            bodyJson: {
          ...oldPagination.nextData,
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: BookNoteModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure, GenericPaginationModel<DefinitionModel>>> getDefinitions({
    required GenericPaginationModel oldPagination,
  }) async {
    try {
      GenericPaginationModel<DefinitionModel> response =
      await GenericRequest<GenericPaginationModel<DefinitionModel>>(
        method: RequestApi.postJson(url: APIEndPoint.definitions,
            bodyJson: {
          ...oldPagination.nextData,
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: DefinitionModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }


  static Future<Either<Failure,bool>> deleteMyReads({int?bookId})async{
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.delete(
          url: APIEndPoint.deleteMyReads(bookId),
        ),
        fromMap: (_)=>true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}