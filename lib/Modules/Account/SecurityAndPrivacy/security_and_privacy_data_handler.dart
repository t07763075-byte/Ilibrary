import 'package:dartz/dartz.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class SecurityAndPrivacyDataHandler {

  static Future<Either<Failure, bool>> deleteMyAccount({required String password}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.customMethod(
          method: "DELETE",
          url: APIEndPoint.deleteMyAccount,
          bodyJson: {
            "password": password
          }
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> changePassword({required String currentPassword,required String newPassword, required String confPassword}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.postJson(
          url: APIEndPoint.changePassword,
          bodyJson: {
            "oldPassword": currentPassword,
            "newPassword": newPassword,
            "confirmNewPassword": confPassword
          }
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> changeEmail({required String email,}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.put(
          url: APIEndPoint.changeEmailOrPhone,
          body: {
            "Email": email,
          }
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
  static Future<Either<Failure, bool>> changePhone({required String phone,required String countryCode,}) async {
    try {
      bool response = await GenericRequest<bool>(
        method: RequestApi.put(
          url: APIEndPoint.changeEmailOrPhone,
          body: {
            "Phone": phone,
            "CountryCode": countryCode,
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