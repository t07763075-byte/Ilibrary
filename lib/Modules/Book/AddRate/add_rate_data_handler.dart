import 'package:dartz/dartz.dart';

import '../../../Models/rating_data_model.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class AddRateDataHandler{

  static Future<Either<Failure,RatingDataModel>> getRatingById({String?ratingById})async{
    try {
      RatingDataModel response = await GenericRequest<RatingDataModel>(
        method: RequestApi.get(url: APIEndPoint.ratingById(ratingById)),
        fromMap: RatingDataModel.fromJson,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}