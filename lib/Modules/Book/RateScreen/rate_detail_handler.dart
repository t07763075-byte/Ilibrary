import 'package:dartz/dartz.dart';
import '../../../Models/generic_pagination_model.dart';
import '../../../Models/rating_model.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class RateDetailHandler {
  static Future<Either<Failure, RatingModel>> getData({
    required GenericPaginationModel oldPagination,
    String? bookId,
    int? rate,
  }) async {
    try {
      RatingModel response = await GenericRequest<RatingModel>(
        method: RequestApi.postJson(
            url: APIEndPoint.getBookRating(bookId),
            bodyJson: {
              ...oldPagination.nextData,
              "filter": {"rate": rate}
            }),
        fromMap: RatingModel.fromJson,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure,bool>> likeAndUnLike({int?ratingId})async{
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
            url: APIEndPoint.addLike(ratingId),
          bodyJson: {}
        ),
        fromMap: (_)=>true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure,RatingModel>> deleteRating({int?ratingId})async{
    try {
      RatingModel response = await GenericRequest<RatingModel>(
        method: RequestApi.delete(
            url: "${APIEndPoint.rating}/$ratingId",
        ),
        fromMap: RatingModel.fromJson,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}
