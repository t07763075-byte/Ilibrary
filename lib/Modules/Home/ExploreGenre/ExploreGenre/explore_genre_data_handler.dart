import 'package:ELibrary/Models/category_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../Models/generic_pagination_model.dart';
import '../../../../Utilities/api_end_point.dart';
import '../../../../core/API/generic_request.dart';
import '../../../../core/API/request_method.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class ExploreGenreDataHandler {
  static Future<Either<Failure, GenericPaginationModel<CategoryModel>>> getExplore(
      {
        required GenericPaginationModel oldPagination,
        String?searchText
      }) async {
    try {

      GenericPaginationModel <CategoryModel> response = await GenericRequest<GenericPaginationModel<CategoryModel>>(
        method: RequestApi.postJson(
            url: APIEndPoint.category,
            bodyJson: {
              "search": searchText,
              "pageSize": 20,
              "pageIndex": oldPagination.currentPageIndex+1,
            },
        ),
        fromMap: (_)=> GenericPaginationModel.fromJson(_,fromJson: CategoryModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
