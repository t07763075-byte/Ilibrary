import 'package:ELibrary/Models/notification_model.dart';
import 'package:dartz/dartz.dart';
import '../../Models/generic_pagination_model.dart';
import '../../Utilities/api_end_point.dart';
import '../../core/API/generic_request.dart';
import '../../core/API/request_method.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';

class NotificationDataHandler{
  static Future<Either<Failure, GenericPaginationModel<NotificationModel>>> getData({
    required GenericPaginationModel oldPagination,

  }) async {
    try {
      GenericPaginationModel<NotificationModel> response =
      await GenericRequest<GenericPaginationModel<NotificationModel>>(
        method: RequestApi.postJson(url: APIEndPoint.notification, bodyJson: {
          ...oldPagination.nextData,

        }),
        fromMap: (_) => GenericPaginationModel.fromJson(_, fromJson: NotificationModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}