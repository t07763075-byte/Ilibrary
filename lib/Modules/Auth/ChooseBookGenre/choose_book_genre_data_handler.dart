import 'package:ELibrary/Models/category_model.dart';
import 'package:dartz/dartz.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class ChooseBookGenreDataHandler {


  static Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    try {
      List<CategoryModel> response = await GenericRequest<CategoryModel>(
        method: RequestApi.postJson(
          url: APIEndPoint.category,
          bodyJson: {
            "pageSize": 9999,
            "pageIndex": 0,
          }
        ),
        fromMap: CategoryModel.fromJson,
      ).getList();

      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> updatePreferred({required List<int> ids}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
          url: APIEndPoint.updatePreferredCategories,
          bodyJson: {
            "preferdCategoriesIds": ids
          }
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

}