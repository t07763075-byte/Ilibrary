import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import '../Utilities/router_config.dart';

class BookLanguageModel {
  final String code;
  final int? id;
  final String? languageName;

  BookLanguageModel({
    required this.code,
    this.id,
  }): languageName = LocaleNames.of(currentContext_!)?.nameOf(code);

  factory BookLanguageModel.fromJson(Map<String, dynamic> json) => BookLanguageModel(
    code: json["code"] ?? "",
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "id": id,
  };
}