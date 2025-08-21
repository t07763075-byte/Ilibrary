import 'package:equatable/equatable.dart';

import '../API/request_method.dart';

enum ExpectType { object, list, other }

class ErrorMessageModel extends Equatable {
  final RequestApi requestApi;
  final Map<String, dynamic>? responseApi;

  final int statusCode;
  final String statusMessage;

  final String? modelName;
  final ExpectType? expectType;

  String get statusCodeName => getStatusCodeName(statusCode);

  static String getStatusCodeName(int statusCode) {
    switch (statusCode) {
      case 200:
        return "OK";
      case 201:
        return "Created";
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'forbidden';
      case 404:
        return 'Not Found';
      case 415:
        return 'Unsupported Media Type';
      case 422:
        return 'UnProcessable Entity | Validation Error';
      case 500:
        return 'Internal Server Error';
      case 501:
        return 'Not Implemented';
      case 503:
        return 'Service Unavailable';
      default:
        return "UnExpected Error";
    }
  }

  ErrorMessageModel({required this.statusCode, String? statusMessage, required this.requestApi, this.responseApi})
      : modelName = null,
        expectType = null,
        statusMessage = statusMessage ?? getStatusCodeName(statusCode);

  const ErrorMessageModel.parsing({
    required this.modelName,
    required this.expectType,
    required this.requestApi,
    required this.statusMessage,
    this.responseApi,
  }) : statusCode = 200;

  ErrorMessageModel.local({
    required this.statusMessage,
  })  : statusCode = 200,
        modelName = null,
        expectType = null,
        requestApi = RequestApi.customMethod(method: "_", url: "_"),
        responseApi = null;

  @override
  String toString() => modelName == null ? "API ERROR: statusCode: $statusCode ,message: $statusMessage" : "PARSING ERROR: modelName: $modelName";

  @override
  List<Object?> get props => [
    statusCode,
    statusMessage,
  ];
}
