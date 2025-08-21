import 'package:dartz/dartz.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class SignUpDataHandler {
  static Future<Either<Failure, bool>> register({required String email,required String phone, required String countryCode,
    required String password, required String confPassword,}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
          url: APIEndPoint.register,
          bodyJson: {
            "email": email,
            "phone": phone,
            "countryCode": countryCode,
            "password": password,
            "confirmPassword": confPassword
          },
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

}