import 'package:dartz/dartz.dart';
import '../../../Models/home_model.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class HomeDataHandler {
  static Future<Either<Failure,HomeModel>> getHome()async{
    try {
      HomeModel response = await GenericRequest<HomeModel>(
        method: RequestApi.get(
            url: APIEndPoint.home,
        ),
        fromMap: HomeModel.fromJson,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}