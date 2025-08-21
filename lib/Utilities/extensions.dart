import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../core/Language/app_languages.dart';

extension LanguagesExtension on Languages {
  String get displayName {
    switch (this) {
      case Languages.ar: return Strings.arabic.tr;
      case Languages.en: return Strings.english.tr;
    }
  }
}

extension DateTimeExtension on TimeOfDay {
  DateTime toDateTime() {
    DateTime timeNow = DateTime.now();
    return DateTime(timeNow.year, timeNow.month, timeNow.day, hour, minute);
  }
}


extension TextSelectionAdapter on TextSelection {
  static TextSelection fromJson(Map<String, dynamic> json){
    return TextSelection(
      baseOffset: json["baseOffset"],
      extentOffset: json["extentOffset"],
      affinity: TextAffinity.values[json["affinity"]],
      isDirectional: json["isDirectional"],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "baseOffset": baseOffset,
      "extentOffset": extentOffset,
      "affinity": affinity.index,
      "isDirectional": isDirectional
    };
  }
}

extension DefaultTextBlockStyleCopyWith on DefaultTextBlockStyle {
  DefaultTextBlockStyle copyWith({required TextStyle style}){
    return DefaultTextBlockStyle(
        this.style.merge(style),
        horizontalSpacing,
        verticalSpacing,
        lineSpacing,
        decoration
    );
  }
}