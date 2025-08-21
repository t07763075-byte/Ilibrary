import 'package:ELibrary/Models/user_model.dart';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class EditProfileDataHandler {

  static Future<Either<Failure, UserModel>> getUserInfo() async {
    try {
      UserModel response = await GenericRequest<UserModel>(
        method: RequestApi.get(
          url: APIEndPoint.getUserInfo,
        ),
        fromMap: UserModel.fromJson,
      ).getObject();
      await SharedPref.saveCurrentUser(user: response.copyWith(token: SharedPref.getCurrentUser()?.token));
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, UserModel>> updateProfileData({required UserModel userModel}) async {
    try {
      List<http.MultipartFile> files = [
        if (userModel.photoUrl != null) await http.MultipartFile.fromPath('ProfileImage', userModel.photoUrl!),
      ];
      UserModel response = await GenericRequest<UserModel>(
        method: RequestApi.put(
          url: APIEndPoint.updateProfile,
          files: files,
          body: userModel.toUpdateProfileJson()
        ),
        fromMap: UserModel.fromJson,
      ).getObject();
      await SharedPref.saveCurrentUser(user: response.copyWith(token: SharedPref.getCurrentUser()?.token));
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

}