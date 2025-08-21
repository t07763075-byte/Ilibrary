import 'package:dartz/dartz.dart';
import '../../../Models/book_model.dart';
import '../../../Models/generic_pagination_model.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../Models/search_history_model.dart';

class SearchDataHandler {
  static Future<Either<Failure, GenericPaginationModel<SearchHistoryModel>>> searchHistory({
    required GenericPaginationModel oldPagination,
  }) async {
    try {
      GenericPaginationModel<SearchHistoryModel> response =
      await GenericRequest<GenericPaginationModel<SearchHistoryModel>>(
        method: RequestApi.postJson(url: APIEndPoint.searchHistory,
            bodyJson: {
          ...oldPagination.nextData,
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: SearchHistoryModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure, GenericPaginationModel<BookModel>>> searchBok({
    required GenericPaginationModel oldPagination,
    String? search,
    int? languageId,
    int? rating,
    String? sort,
  }) async {

    try {
      GenericPaginationModel<BookModel> response =
      await GenericRequest<GenericPaginationModel<BookModel>>(
        method: RequestApi.postJson(url: APIEndPoint.searchBook,
            bodyJson: {
          ...oldPagination.nextData,
              "search":search,
               "isDesc":sort=="TotalRating"? true:false,
              if(sort!=null)"orderByColumn":sort,
              "filter": {
                if(rating!=null)"rating": rating,
                if(languageId!=null) "bookLanguageId": languageId,
              }
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: BookModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure, bool>> deleteSearchHistory({
    int? id
  }) async {
    try {
      bool response =
      await GenericRequest<bool>(
        method: RequestApi.delete(url: APIEndPoint.deleteSearchHistory(id),),
        fromMap: (_) => true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
