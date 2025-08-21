import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../Models/language_model.dart';
import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Widgets/custom_button_widget.dart';

class ExplanationWidget extends StatelessWidget {
  final String explanation;
   const ExplanationWidget({super.key, required this.explanation});
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(44.r),topRight: Radius.circular(44.r)),
        border: Border(
          top: BorderSide(color: ThemeClass.of(context).alertBackground,),
        ),
        color: ThemeClass.of(context).cartColor
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(8.h),
            Center(
              child: Container(height: 3.h,
                width:38.w ,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: ThemeClass.of(context).alertBackground
                ),),
            ),
            Gap(24.h),
            Text(Strings.explanation.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
            Gap(24.h),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 120.h,
                maxHeight: 600.h,
                minWidth: double.infinity,
                maxWidth: double.infinity
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: ThemeClass.of(context).borderColor,)
                ),
                padding: EdgeInsets.all(12.r),
                child: Text(explanation,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
              ),
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}

class SelectExplainLanguage extends StatefulWidget {
  final void Function(LanguageModel language) onSelectLanguage;
  const SelectExplainLanguage({super.key, required this.onSelectLanguage});

  @override
  State<SelectExplainLanguage> createState() => _SelectExplainLanguageState();
}

class _SelectExplainLanguageState extends State<SelectExplainLanguage> {

  LanguageModel? selectedLanguage;

  List<LanguageModel> languages = [
    LanguageModel(name: Strings.arabic.tr, id: 1),
    LanguageModel(name: Strings.english.tr, id: 2),
    LanguageModel(name: Strings.french.tr, id: 3),
    LanguageModel(name:Strings.german.tr, id: 4),
    LanguageModel(name: Strings.italian.tr, id: 5),
    LanguageModel(name: Strings.spanish.tr, id: 6),
    LanguageModel(name: Strings.japanese.tr, id: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 760.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(44.r),topRight: Radius.circular(44.r)),
          border: Border(
            top: BorderSide(color: ThemeClass.of(context).alertBackground,),
          ),
          color: ThemeClass.of(context).cartColor
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(8.h),
          Center(
            child: Container(
              height: 3.h,
              width: 40.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: ThemeClass.of(context).alertBackground
              ),
            ),
          ),
          Gap(24.h),
          Row(
            children: [
              InkWell(onTap: ()=> context.pop(),child: Icon(Icons.arrow_back_outlined,color: ThemeClass.of(context).primaryColor,)),
              Gap(8.w),
              Text(Strings.selectLanguage.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
            ],
          ),
          Gap(24.h),
          ...languages.map((language){
            return InkWell(
              onTap: ()=> setState(() {selectedLanguage = language;}),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.name ?? "",style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: ThemeClass.of(context).primaryColor,
                    ),
                    child: Radio<LanguageModel>(
                      activeColor: ThemeClass.of(context).primaryColor,
                      value: language,
                      groupValue: selectedLanguage,
                      onChanged: (_)=> setState(() {selectedLanguage = _!;}),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: languages.length,
          //     itemBuilder: (_,i)=> InkWell(
          //       onTap: ()=> setState(() {selectedLanguage = languages[i];}),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(languages[i].name ?? "",style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),
          //           Theme(
          //             data: Theme.of(context).copyWith(
          //               unselectedWidgetColor: ThemeClass.of(context).primaryColor,
          //             ),
          //             child: Radio<LanguageModel>(
          //               activeColor: ThemeClass.of(context).primaryColor,
          //               value: languages[i],
          //               groupValue: selectedLanguage,
          //               onChanged: (_)=> setState(() {selectedLanguage = _!;}),
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Gap(24.h),
          if(selectedLanguage == null) Center(
            child: CustomButtonWidget.customPrimary(
              height: 56.h,
              backgroundColor: ThemeClass.of(context).darkGreyColor,
              child: Text(Strings.confirm.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: Colors.white),),
            ),
          ),
          if(selectedLanguage != null) Center(
            child: CustomButtonWidget.primary(
              height: 56.h,
              title: Strings.confirm.tr,
              onTap: ()=> widget.onSelectLanguage(selectedLanguage!),
            ),
          ),
          Gap(24.h),
        ],
      ),
    );
  }
}