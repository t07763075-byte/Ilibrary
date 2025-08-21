import 'package:ELibrary/Models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class SignInDataHandler {

  static Future<Either<Failure, UserModel>> login({required String emailOrPhone,required String password, required countryCode}) async {
    try {
      UserModel response = await GenericRequest<UserModel>(
        method: RequestApi.postJson(
            url: APIEndPoint.login,
            bodyJson: {
              "emailOrPhone": emailOrPhone,
              "countryCode": countryCode,
              "password": password
            }
        ),
        fromMap: UserModel.fromJson,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

}