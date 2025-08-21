import 'package:dartz/dartz.dart';
import '../../../Models/book_model.dart';
import '../../../Models/generic_pagination_model.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../Utilities/enum.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class HomeItemsDataHandler {
  static Future<Either<Failure, GenericPaginationModel<BookModel>>> getData({
    required GenericPaginationModel oldPagination,
    HomeType? homeType,
    String?search
  }) async {
    try {
      GenericPaginationModel<BookModel> response =
          await GenericRequest<GenericPaginationModel<BookModel>>(
        method: RequestApi.postJson(url: APIEndPoint.homeSection, bodyJson: {
          ...oldPagination.nextData,
          "search":search??'',
          "filter": {"sectionId": homeType?.index}
        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: BookModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
