import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_extended/state_extended.dart';
import '../../../../core/Theme/theme_provider.dart';
import '../../core/Font/font_provider.dart';

class AppearanceController extends StateXController {
  // singleton
  factory AppearanceController() => _this ??= AppearanceController._();
  static AppearanceController? _this;
  AppearanceController._();

  int? selectedMode;

  late Color accentPpickedColor;
  late Color primaryPickedColor;
  void changeAccentColor(Color newColor){
    accentPpickedColor = newColor;
    setState(() { });
  }


  void changePrimaryColor(Color newColor){
    primaryPickedColor = newColor;
    setState(() { });
  }

  void changeMode(int newMode,{required BuildContext context}) {
    selectedMode = newMode;
    setState(() {});
  }

  saveThemeChanges(BuildContext context) async{
    final appTheme = Provider.of<ThemeProvider>(context,listen: false);
    if(selectedMode == null) return;
    await appTheme.changeTheme(theme: appTheme.appTheme.copyWith(
      isDark: selectedMode == 2,
      primaryColor: primaryPickedColor,
      successColor: accentPpickedColor,
    ));
    setState(() { });
  }

  addToFontSize(BuildContext context) async{
    final appTheme = Provider.of<FontProvider>(context,listen: false);
    if(selectedMode == null) return;
    await appTheme.changeFontSizeScale(fontSizeScale: (appTheme.fontSizeScale+0.2));
    setState(() { });
  }

  remToFontSize(BuildContext context) async{
    final appTheme = Provider.of<FontProvider>(context,listen: false);
    if(selectedMode == null) return;
    await appTheme.changeFontSizeScale(fontSizeScale: (appTheme.fontSizeScale-0.2));
    setState(() { });
  }

  changeFontFamilyCairo(BuildContext context) async{
    final appTheme = Provider.of<FontProvider>(context,listen: false);
    if(selectedMode == null) return;
    await appTheme.changeFontFamily(fontFamily: FontFamilyTypes.cairo);
    setState(() { });
  }
  changeFontFamilyAlex(BuildContext context) async{
    final appTheme = Provider.of<FontProvider>(context,listen: false);
    if(selectedMode == null) return;
    await appTheme.changeFontFamily(fontFamily: FontFamilyTypes.urbanist);
    setState(() { });
  }

}
