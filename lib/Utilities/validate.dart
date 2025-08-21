import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';


class Validate{
  static String? validatePassword(String? password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$');
    if(password!=null && password.length>=8 && regex.hasMatch(password)) return null;
    return "";
  }

  static String? validateConfPassword({required String newPassword, required String confPassword}) {
    if(newPassword.characters==confPassword.characters) return null;
    return "${Strings.confirmPassword.tr} ${Strings.errorFiledMessage.tr}";
  }
  static String? validateEmail(String? email) {
      if (email == null || email.isEmpty) return "${Strings.email.tr} ${Strings.errorFiledMessage.tr}";
      return null;
  }

  static String? validateNormalString(String? text) {
    if (text?.isEmpty ?? true) return "";
    return null;
  }

  static String? validateName(String? text) {
    final regex = RegExp(r'^[a-zA-Z]{2,}$');

    if (!regex.hasMatch(text ?? "")) return "";
    return null;
  }

  static String? validateDropDown(dynamic value) {
    return value == null?"":null;
  }
  static String? validatePhoneNumber(String? value) {
    // final regex = RegExp(r'^01(0|1|2|5)\d{8}$'); // this is for egypt only
    if (value == null || value.isEmpty) return "${Strings.phoneNumber.tr} ${Strings.errorFiledMessage.tr}";
    return null;
    // if (value!.isEmpty) {
    //   return "";
    // }
    // Pattern pattern = r'(^(0)(5)[0-9]{8}$)';
    // Pattern pattern2 = r'(^(٠)(٥)[٠-٩]{8}$)';
    // RegExp regex =  RegExp(pattern as String);
    // RegExp regex2 =  RegExp(pattern2 as String);
    // if (!regex.hasMatch(value) && !regex2.hasMatch(value)) return "";
    // return null;

  }
}