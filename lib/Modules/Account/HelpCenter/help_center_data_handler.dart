import 'dart:convert';
import 'dart:typed_data';

import 'package:ELibrary/Utilities/generic_file.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../Models/faq_model.dart';
import '../../../Models/generic_pagination_model.dart';
import '../../../Utilities/api_end_point.dart';
import '../../../core/API/generic_request.dart';
import '../../../core/API/request_method.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';

class HelpCenterDataHandler{
  static Future<Either<Failure, GenericPaginationModel<FAQModel>>> getFAQs({required GenericPaginationModel oldPagination}) async {
    try {
      GenericPaginationModel <FAQModel> response = await GenericRequest<GenericPaginationModel<FAQModel>>(
        method: RequestApi.postJson(
          url: APIEndPoint.faqsList,
          bodyJson: oldPagination.nextData,
        ),
        fromMap: (_)=> GenericPaginationModel.fromJson(_,fromJson: FAQModel.fromJson),
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, bool>> createTicket({required int issueType, required String subject,
    required String description, required String email, List<GenericFile> documents = const []}) async {
    try {
      List<http.MultipartFile> files = documents.mapIndexed((index,file)=> http.MultipartFile.fromBytes('Documents[$index]', file.bytes, filename: file.filename,)).toList();
      bool response = await GenericRequest<bool>(
        method: RequestApi.post(
          url: APIEndPoint.createTicket,
          files: files,
          body: {
            "Type": issueType.toString(),
            "subject": subject,
            "description": description,
            "email": email,
            "phone": "",
          },
        ),
        fromMap: (_)=> true,
      ).getResponse();
      return Right(response);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, String>> getPrivacyPolicy() async {
    try {
      Uint8List response = await GenericRequest(
        fromMap: (_)=> _,
        method: RequestApi.get(url: APIEndPoint.privacyPolicyPage,),
      ).getResponseBytes();
      return Right(utf8.decode(response));
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }

  static Future<Either<Failure, String>> getTermsConditions() async {
    try {
      Uint8List response = await GenericRequest(
        fromMap: (_)=> _,
        method: RequestApi.get(url: APIEndPoint.termsConditionsPage,),
      ).getResponseBytes();
      return Right(utf8.decode(response));
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    }
  }
}