import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../Utilities/shared_preferences.dart';
import '../../Utilities/theme_helper.dart';

class ThemeModel extends ThemeExtension<ThemeModel> {

  static ThemeModel get defaultTheme{
    return ThemeClass.darkTheme();
    Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark? ThemeClass.darkTheme():ThemeClass.lightTheme();
  }

  final bool isDark;
  final Color primaryColor;
  final Color shadePrimaryColor;
  final Color backGroundColor;
  final Color mainTextColor;
  final Color bodyTextColor;
  final Color successColor;
  final Color darkGreyColor;
  final Color lightGreyColor;
  final Color warningColor;
  final Color hintColor;
  final Color alertBackground;
  final Color cartColor;
  final Color borderColor;

  ThemeModel({
    this.isDark = false,
    required this.primaryColor,
    required this.successColor,
    required this.shadePrimaryColor,
    required this.backGroundColor,
    required this.mainTextColor,
    required this.bodyTextColor,
    required this.darkGreyColor,
    required this.lightGreyColor,
    required this.warningColor,
    required this.hintColor,
    required this.alertBackground,
    required this.cartColor,
    required this.borderColor,
  });

  @override
  ThemeModel copyWith({
    bool? isDark,
    Color? primaryColor,
    Color? successColor,
    Color? backGroundColor,
    Color? mainTextColor,
    Color? bodyTextColor,
    Color? darkGreyColor,
    Color? lightGreyColor,
    Color? shadePrimaryColor,
    Color? warningColor,
    Color? hintColor,
    Color? alertBackground,
    Color? cartColor,
    Color? borderColor,
  }) {
    return ThemeModel(
      isDark: isDark ?? this.isDark,
      primaryColor: primaryColor ?? this.primaryColor,
      shadePrimaryColor: shadePrimaryColor ?? this.shadePrimaryColor,
      successColor: successColor ?? this.successColor,
      backGroundColor: backGroundColor ?? this.backGroundColor,
      darkGreyColor: darkGreyColor ?? this.darkGreyColor,
      lightGreyColor: lightGreyColor ?? this.lightGreyColor,
      warningColor: warningColor ?? this.warningColor,
      mainTextColor: mainTextColor ?? this.mainTextColor,
      bodyTextColor: bodyTextColor ?? this.bodyTextColor,
      hintColor: hintColor ?? this.hintColor,
      alertBackground: alertBackground ?? this.alertBackground,
      cartColor: cartColor ?? this.cartColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  factory ThemeModel.fromJson(Map<String, dynamic> json) => ThemeModel(
      isDark: json["isDark"],
      primaryColor: Color(json["primaryColor"]),
      successColor: Color(json["successColor"]),
      backGroundColor: Color(json["backGroundColor"]),
      darkGreyColor: Color(json["darkGreyColor"]),
      lightGreyColor: Color(json["lightGreyColor"]),
      warningColor: Color(json["warningColor"]),
      mainTextColor: Color(json["mainTextColor"]),
      bodyTextColor: Color(json["bodyTextColor"]),
      shadePrimaryColor: Color(json["shadePrimaryColor"]),
      hintColor: Color(json["hintColor"]),
      alertBackground: Color(json["alertBackground"]),
      cartColor: Color(json["cartColor"]),
      borderColor: Color(json["borderColor"]));

  Map<String, dynamic> toJson() => {
        "isDark": isDark,
        "primaryColor": primaryColor.value,
        "successColor": successColor.value,
        "backGroundColor": backGroundColor.value,
        "darkGreyColor": darkGreyColor.value,
        "lightGreyColor": lightGreyColor.value,
        "shadePrimaryColor": shadePrimaryColor.value,
        "warningColor": warningColor.value,
        "mainTextColor": mainTextColor.value,
        "bodyTextColor": bodyTextColor.value,
        "cartColor": cartColor.value,
        "alertBackground": alertBackground.value,
        "borderColor": borderColor.value,
      };

  @override
  ThemeModel lerp(ThemeExtension<ThemeModel>? other, double t) {
    if (other is! ThemeModel) {
      return this;
    }
    return SharedPref.getTheme() ?? defaultTheme;
  }
}
