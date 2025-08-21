import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


import '../core/Font/font_provider.dart';

class TextStyleHelper{
  final BuildContext context;
  TextStyleHelper._(this.context);

  static TextStyleHelper of(BuildContext context) => TextStyleHelper._(context);

  double get _fSS => Provider.of<FontProvider>(context,listen: false).fontSizeScale;
  FontFamilyTypes get _fF => Provider.of<FontProvider>(context,listen: false).fontFamily;

  _fontFamily(){
    switch(_fF){
      case FontFamilyTypes.urbanist: return GoogleFonts.urbanist;
      case FontFamilyTypes.cairo: return GoogleFonts.cairo;
    }
  }

  TextStyle  getTextStyle({required double fontSize,FontWeight? fontWeight}) =>
      _fontFamily()(fontSize: (fontSize*_fSS).sp,fontWeight: fontWeight,color: ThemeClass.of(context).mainTextColor);


  TextStyle get s8RegTextStyle => getTextStyle(fontSize: 10);
  TextStyle get s10RegTextStyle => getTextStyle(fontSize: 10);
  TextStyle get s12RegTextStyle => getTextStyle(fontSize: 12);
  TextStyle get s14RegTextStyle => getTextStyle(fontSize: 14);
  TextStyle get s16RegTextStyle => getTextStyle(fontSize: 16);
  TextStyle get s18RegTextStyle => getTextStyle(fontSize: 18);
  TextStyle get s22RegTextStyle => getTextStyle(fontSize: 22);
  TextStyle get s24RegTextStyle => getTextStyle(fontSize: 24);
  TextStyle get s26RegTextStyle => getTextStyle(fontSize: 26);
  TextStyle get s28RegTextStyle => getTextStyle(fontSize: 28);
  TextStyle get s32RegTextStyle => getTextStyle(fontSize: 32);
  TextStyle get s36RegTextStyle => getTextStyle(fontSize: 36);
  TextStyle get s45RegTextStyle => getTextStyle(fontSize: 45);

  TextStyle get s8SemiBoldTextStyle => getTextStyle(fontSize: 8,fontWeight: FontWeight.w600);
  TextStyle get s10SemiBoldTextStyle => getTextStyle(fontSize: 10,fontWeight: FontWeight.w700);
  TextStyle get s12SemiBoldTextStyle => getTextStyle(fontSize: 12,fontWeight: FontWeight.w700);
  TextStyle get s14SemiBoldTextStyle => getTextStyle(fontSize: 14,fontWeight: FontWeight.w700);
  TextStyle get s16SemiBoldTextStyle => getTextStyle(fontSize: 16,fontWeight: FontWeight.w700);
  TextStyle get s18SemiBoldTextStyle => getTextStyle(fontSize: 18,fontWeight: FontWeight.w700);
  TextStyle get s20SemiBoldTextStyle => getTextStyle(fontSize: 20,fontWeight: FontWeight.w700);
  TextStyle get s22SemiBoldTextStyle => getTextStyle(fontSize: 22,fontWeight: FontWeight.w700);
  TextStyle get s24SemiBoldTextStyle => getTextStyle(fontSize: 24,fontWeight: FontWeight.w700);
  TextStyle get s26SemiBoldTextStyle => getTextStyle(fontSize: 26,fontWeight: FontWeight.w700);
  TextStyle get s28SemiBoldTextStyle => getTextStyle(fontSize: 28,fontWeight: FontWeight.w700);
  TextStyle get s32SemiBoldTextStyle => getTextStyle(fontSize: 32,fontWeight: FontWeight.w700);
  TextStyle get s36SemiBoldTextStyle => getTextStyle(fontSize: 36,fontWeight: FontWeight.w700);
  TextStyle get s45SemiBoldTextStyle => getTextStyle(fontSize: 45,fontWeight: FontWeight.w700);
}