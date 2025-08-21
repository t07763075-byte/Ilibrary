import 'package:ELibrary/Models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class CreatePasswordDataHandler {

  static Future<Either<Failure, UserModel>> createPassword({required String emailOrPhone,required String password,required String confPassword, required String? countryCode}) async {
    try {
      UserModel response = await GenericRequest<UserModel>(
        method: RequestApi.postJson(
          url: APIEndPoint.createPassword,
          bodyJson: {
            "emailOrPhone": emailOrPhone,
            "countryCode": countryCode,
            "password": password,
            "confirmPassword": confPassword
          }
        ),
        fromMap: UserModel.fromJson,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

}