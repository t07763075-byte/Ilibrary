import 'package:ELibrary/Utilities/dialog_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Utilities/strings.dart';
import '../../../../../Utilities/theme_helper.dart';
import '../../../Utilities/shared_preferences.dart';
import '../../../Utilities/text_style_helper.dart';
import '../../../Widgets/color_picker_dialog.dart';
import '../appearance_controller.dart';

class LargeAppearanceScreen extends StatefulWidget {
  const LargeAppearanceScreen({super.key});

  @override
  State createState() => _LargeAppearanceScreenState();
}

class _LargeAppearanceScreenState extends StateX<LargeAppearanceScreen> {
  _LargeAppearanceScreenState() : super(controller: AppearanceController()) {
    con = controller as AppearanceController;
  }

  late AppearanceController con;


  @override
  void initState() {
    con.accentPpickedColor = ThemeClass.of(context).successColor;
    con.primaryPickedColor = ThemeClass.of(context).primaryColor;
    con.selectedMode = (SharedPref.getTheme()?.isDark??false)?2:1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: ()=> con.saveThemeChanges(context),
                            child: Container(
                              width: 150.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: ThemeClass.of(context).primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Text("save",style: TextStyleHelper.of(context).s32RegTextStyle,),
                            ),
                          ),
                          InkWell(
                            onTap: ()=> con.addToFontSize(context),
                            child: Container(
                              width: 150.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: ThemeClass.of(context).primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Text("Font Size +",style: TextStyleHelper.of(context).s32RegTextStyle,),
                            ),
                          ),
                          InkWell(
                            onTap: ()=> con.remToFontSize(context),
                            child: Container(
                              width: 150.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: ThemeClass.of(context).primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Text("Font Size -",style: TextStyleHelper.of(context).s32RegTextStyle,),
                            ),
                          ),
                          InkWell(
                            onTap: ()=> con.changeFontFamilyCairo(context),
                            child: Container(
                              width: 150.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: ThemeClass.of(context).primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Text("Font to cairo",style: TextStyleHelper.of(context).s32RegTextStyle,),
                            ),
                          ),
                          InkWell(
                            onTap: ()=> con.changeFontFamilyAlex(context),
                            child: Container(
                              width: 150.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: ThemeClass.of(context).primaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Text("Font to Alex",style: TextStyleHelper.of(context).s32RegTextStyle,),
                            ),
                          ),
                          //*   dark mode
                          InkWell(
                            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                            onTap: () => con.changeMode(2,context: context),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 188.w,
                                  height: 144.h,
                                  child: SvgPicture.asset("assets/images/darkMode.svg",fit: BoxFit.fill,)),
                                SizedBox(height: 16.h),
                                Row(
                                    children: [
                                      Text(Strings.dark.tr,style: TextStyleHelper.of(context).s24RegTextStyle,),
                                    SizedBox(width: 8.w),
                                      Radio<int>(
                                        activeColor: ThemeClass.of(context).successColor,fillColor: MaterialStatePropertyAll(ThemeClass.of(context).successColor),
                                        value: 2, groupValue: con.selectedMode, onChanged:(_)=> con.changeMode(_!,context: context),),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          SizedBox(width: 32.w),
                          //*   light mode
                          InkWell(

                            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                            onTap: () => con.changeMode(1,context: context),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 188.w,
                                  height: 144.h,
                                  child: SvgPicture.asset("assets/images/lightMode.svg",fit: BoxFit.fill,
                                  )),
                                SizedBox(height: 16.h),
                                Row(
                                        children: [
                                          Text(Strings.light.tr,style: TextStyleHelper.of(context).s24RegTextStyle,),
                                      SizedBox(width: 8.w),
                                          Radio<int>(
                                            hoverColor: Colors.transparent, overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                                            activeColor: ThemeClass.of(context).successColor,fillColor: MaterialStatePropertyAll(ThemeClass.of(context).successColor),
                                    value: 1, groupValue: con.selectedMode, onChanged: (_)=> con.changeMode(_!,context: context),),
                                        ],
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 32.h),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            width: (SampleColors.appThemePrimaryColors.length*50.r + (SampleColors.appThemePrimaryColors.length-1) *16.w),
                            height: 58.r,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: SampleColors.appThemePrimaryColors.length,
                              separatorBuilder: (context, index) => SizedBox(width: 16.w),
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  setState(() {con.primaryPickedColor = SampleColors.appThemePrimaryColors[index];});
                                },
                                child: CircleAvatar(
                                  radius: 25.r,
                                  backgroundColor: SampleColors.appThemePrimaryColors[index],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 64.w),
                          Container(
                            width: 50.r,
                            height: 50.r,
                            padding: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: ThemeClass.of(context).darkGreyColor),
                              shape: BoxShape.circle
                            ),
                            child: CircleAvatar(
                              radius: 16.r,
                              backgroundColor: con.primaryPickedColor,
                              //backgroundColor: con.selectedPrimaryColor,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          InkWell(
                            onTap: (){
                              DialogHelper.custom(
                                context: context,
                              ).customDialog (dialogWidget: ColorPickerDialog(pickedColor: con.primaryPickedColor, onColorChanged: con.changePrimaryColor));
                            },
                            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                            child: SvgPicture.asset("assets/images/brush.svg", height: 24.r, width: 24.r,)),
                          const Spacer(flex: 3,),
                          Text(Strings.mainColor.tr,style: TextStyleHelper.of(context).s24RegTextStyle,),

                          const Spacer(flex: 5,),
                        ],
                      ),
                      SizedBox(height: 32.h),
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            width: (SampleColors.appThemeAccentColors.length*50.r + (SampleColors.appThemeAccentColors.length-1) *16.w),
                            height: 58.r,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: SampleColors.appThemeAccentColors.length,
                              separatorBuilder: (context, index) => SizedBox(width: 16.w,),
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  setState(() {con.accentPpickedColor = SampleColors.appThemeAccentColors[index];});
                                },
                                child: CircleAvatar(
                                  radius: 25.r,
                                  backgroundColor: SampleColors.appThemeAccentColors[index],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 64.w),
                          Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: ThemeClass.of(context).darkGreyColor),
                              shape: BoxShape.circle
                            ),
                            padding: EdgeInsets.all(2.r),
                            child: CircleAvatar(
                              radius: 16.r,
                              backgroundColor: con.accentPpickedColor,
                              //backgroundColor: con.selectedSecondaryColor,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          InkWell(
                            onTap: (){

                              DialogHelper.custom(
                                context: context,
                              ).customDialog(dialogWidget: ColorPickerDialog(pickedColor: con.accentPpickedColor, onColorChanged: con.changeAccentColor));
                            },
                            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                            child: SvgPicture.asset("assets/images/brush.svg", height: 24.r, width: 24.r,)),
                          const Spacer(flex: 3,),
                          Text(Strings.secondaryColor.tr,style: TextStyleHelper.of(context).s24RegTextStyle,),
                          const Spacer(flex: 5,),
                        ],
                      )
                    ],
                  ),
      ),
    );
  }
}

class SampleColors {
  static const List<Color> appThemePrimaryColors = [
    Color(0xff1C5A92),
    Color(0xD5F1640C),
    Color(0xda4bb9b9),
    Color(0xff154e67),
  ];

  static const List<Color> appThemeAccentColors = [
    Color(0xff8CA5BE),
    Color(0xffff9955),
    Color(0xff7ffdfc),
    Color(0xff6baffb),
  ];
}
