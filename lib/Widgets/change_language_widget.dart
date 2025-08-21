import 'package:ELibrary/Utilities/extensions.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/app_languages.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../Utilities/theme_helper.dart';

class ChangeLanguageWidget extends StatefulWidget {
  final Function(Languages) onConfirm;

  const ChangeLanguageWidget({super.key, required this.onConfirm});

  @override
  State<ChangeLanguageWidget> createState() => _ChangeLanguageWidgetState();
}

class _ChangeLanguageWidgetState extends State<ChangeLanguageWidget> {
  late Languages selectedLanguage;

  @override
  void initState() {
    selectedLanguage = appLangIsArabic()? Languages.ar : Languages.en;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Theme(
      data: Theme.of(context).copyWith(
          unselectedWidgetColor: ThemeClass.of(context).mainTextColor,
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(8.h),
            Center(
              child: Container(
                height: 3.h,
                width:38.w ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: ThemeClass.of(context).alertBackground),
              ),
            ),
            Gap(24.h),
            Text(Strings.language.tr,style: TextStyleHelper.of(context).s24SemiBoldTextStyle,),
            Gap(24.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Languages.values.length,
              itemBuilder: (_,index){
                return ListTile(
                  onTap:()=> setState(()=> selectedLanguage = Languages.values[index]),
                  title: Text(Languages.values[index].displayName,style: TextStyleHelper.of(context).s20SemiBoldTextStyle),
                  contentPadding: EdgeInsets.zero,
                  trailing: Radio<Languages>(
                    value: Languages.values[index],
                    activeColor: ThemeClass.of(context).primaryColor,
                    groupValue: selectedLanguage,
                    onChanged: (_){},
                  ),
                );
              },
              separatorBuilder: (_,index)=> Gap(24.h),
            ),
            Gap(24.h),
            CustomButtonWidget.primary(
              height: 56.h,
              title: Strings.confirm.tr,
              onTap: ()=> widget.onConfirm(selectedLanguage),
            ),
            Gap(36.h)
          ],
        ),
      ),
    );
  }
}
