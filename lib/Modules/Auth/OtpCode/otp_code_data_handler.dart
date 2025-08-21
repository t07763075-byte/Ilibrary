import 'package:ELibrary/Models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../Utilities/shared_preferences.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class OtpCodeDataHandler {

  static Future<Either<Failure, UserModel>> verifyOtp({required String emailOrPhone, required String countryCode, required String otpCode,}) async {
    try {
      UserModel response = await GenericRequest<UserModel>(
        method: RequestApi.postJson(
          url: APIEndPoint.verifyOtp,
          bodyJson: {
            "emailOrPhone": emailOrPhone,
            "countryCode": countryCode,
            "otp": otpCode
          }
        ),
        fromMap: UserModel.fromJson,
      ).getObject();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, UserModel>> verifyChangeEmailOrPhone({required String otpCode,}) async {
    try {
      UserModel response = await GenericRequest<UserModel>(
        method: RequestApi.postJson(
          url: APIEndPoint.verifyChangeEmailOrPhoneOtp,
          bodyJson: {
            "otp": otpCode
          }
        ),
        fromMap: UserModel.fromJson,
      ).getObject();
      await SharedPref.saveCurrentUser(user: response);
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> resendOtp({required String emailOrPhone, required String countryCode}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
          url: APIEndPoint.resendOtp,
          bodyJson: {
            "emailOrPhone": emailOrPhone,
            "countryCode": countryCode,
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