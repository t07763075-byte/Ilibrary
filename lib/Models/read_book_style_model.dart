
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum ReadBookFamilyTypes {urbanist,roboto,sourceSansPro,georgian,poppins,inriaSerif,goudy}

List<Color> bookBackgroundColors=const[
  Color(0xffFFFFFF),
  Color(0xffFAF9F6),
  Color(0xffCCCCCC),

  Color(0xffA9A9A9),
  Color(0xff191970),
  Color(0xff181A20),
];
List<Color> bookFontColors=const[
  Color(0xff222222),
  Color(0xff222222),
  Color(0xff222222),

  Color(0xffeeeeee),
  Color(0xffeeeeee),
  Color(0xffeeeeee),
];

TextStyle _getReadBookFontFamily(ReadBookFamilyTypes? type){
  switch(type){
    case ReadBookFamilyTypes.urbanist: return GoogleFonts.urbanist();
    case ReadBookFamilyTypes.roboto: return GoogleFonts.roboto();
    case ReadBookFamilyTypes.sourceSansPro: return GoogleFonts.sourceSansPro();
    case ReadBookFamilyTypes.georgian: return GoogleFonts.notoSerifGeorgian();
    case ReadBookFamilyTypes.poppins: return GoogleFonts.poppins();
    case ReadBookFamilyTypes.inriaSerif: return GoogleFonts.inriaSerif();
    case ReadBookFamilyTypes.goudy: return GoogleFonts.goudyBookletter1911();
    case null: return const TextStyle(color: null);
  }
}

class ReadBookStyleModel{
  final Color backgroundColor;
  final Color fontColor;
  final ReadBookFamilyTypes? fontFamily;
  final double fontSizeFactor;
  final int brightness;

  TextStyle getTextStyle(double? fontSize) => _getReadBookFontFamily(fontFamily).copyWith(
    fontSize: fontSize == null? null: (fontSize * fontSizeFactor).sp + (MediaQuery.sizeOf(currentContext_!).width / 50),
    color: fontColor,
  );

  ReadBookStyleModel({required this.backgroundColor,required this.fontFamily,required this.fontSizeFactor,
    required this.brightness,required this.fontColor});

  static ReadBookStyleModel defaultStyle = ReadBookStyleModel(
    backgroundColor: bookBackgroundColors.last,
    fontColor: bookFontColors.last,
    fontFamily: null,
    fontSizeFactor: 1,
    brightness: 100,
  );


  ReadBookStyleModel copyWith({Color? backgroundColor,Color? fontColor,ReadBookFamilyTypes? fontFamily,double? fontSizeFactor,
    TextAlign? textAlign,int? brightness,}){
    return ReadBookStyleModel(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSizeFactor: fontSizeFactor ?? this.fontSizeFactor,
      brightness: brightness ?? this.brightness,
      fontColor: fontColor ?? this.fontColor,
    );
  }


  factory ReadBookStyleModel.fromJson(Map<String,dynamic> json){
    return ReadBookStyleModel(
      backgroundColor: Color(json["backgroundColor"]),
      fontColor: Color(json["fontColor"]),
      fontFamily: json["fontFamily"] == null ? null : ReadBookFamilyTypes.values[json["fontFamily"]],
      fontSizeFactor: json["fontSizeFactor"],
      brightness: json["brightness"],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "backgroundColor": backgroundColor.value,
      "fontColor": fontColor.value,
      "fontFamily": fontFamily?.index,
      "fontSizeFactor": fontSizeFactor,
      "brightness": brightness,
    };
  }

}