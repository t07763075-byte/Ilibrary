import 'package:ELibrary/core/API/request_method.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import 'generic_request.dart';

class RequestDataHandler{
  static Future<Either<Failure,dynamic>> executeRequestApi({required RequestApi requestApi})async{
    try {
      dynamic response = await GenericRequest<dynamic>(
        method: requestApi,
        fromMap: (_)=> _,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}

class UploadRequestProgressProvider extends ChangeNotifier{
  int? bytes, totalBytes;

  void updateRequestOnProgress({required int? bytes,required int? totalBytes}){
    this.bytes = bytes;
    this.totalBytes = totalBytes;
    notifyListeners();
  }
}

class DownloadRequestProgressProvider extends ChangeNotifier{
  int? bytes, totalBytes;
  double get progress => totalBytes != null && totalBytes! > 0 ? (bytes ?? 0) / totalBytes! : 0.0;
  void updateRequestOnProgress({required int? bytes,required int? totalBytes}){
    this.bytes = bytes;
    this.totalBytes = totalBytes;
    notifyListeners();
  }
}