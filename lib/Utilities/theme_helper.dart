import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/Theme/theme_model.dart';
import '../core/Theme/theme_provider.dart';

class ThemeClass extends ThemeModel{

  static ThemeModel of(BuildContext context) => Provider.of<ThemeProvider>(context,listen: false).appTheme;


  ThemeClass.lightTheme({
    super.isDark= false,
    super.backGroundColor=const Color(0xff181A20),
    super.primaryColor= const Color(0xffF89300),
    super.shadePrimaryColor= const Color(0xffFEF4E6),
    super.mainTextColor= const Color(0xffFFFFFF),
    super.bodyTextColor= const Color(0xffFAFAFA),
    super.warningColor=const Color(0xffF75555),
    super.darkGreyColor= const Color(0xff9E9E9E),
    super.successColor= const Color(0xff12D18E),
    super.hintColor= const Color(0xffE0E0E0),
    super.alertBackground= const Color(0xFF35383F),
    super.lightGreyColor= const Color(0xffaaaaaa),
    super.cartColor= const Color(0xff1F222A),
    super.borderColor= const Color(0xff424242),
  });

  ThemeClass.darkTheme({
    super.isDark= true,
    super.backGroundColor=const Color(0xff181A20),
    super.primaryColor= const Color(0xffF89300),
    super.shadePrimaryColor= const Color(0xffFEF4E6),
    super.mainTextColor= const Color(0xffFFFFFF),
    super.bodyTextColor= const Color(0xffFAFAFA),
    super.warningColor=const Color(0xffF75555),
    super.darkGreyColor= const Color(0xff9E9E9E),
    super.successColor= const Color(0xff12D18E),
    super.hintColor= const Color(0xffE0E0E0),
    super.alertBackground= const Color(0xFF35383F),
    super.lightGreyColor= const Color(0xffaaaaaa),
    super.cartColor= const Color(0xff1F222A),
    super.borderColor= const Color(0xff424242),
  });
}