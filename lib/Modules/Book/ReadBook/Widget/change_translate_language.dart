import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../Models/book_language_model.dart';
import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Widgets/custom_button_widget.dart';
import '../../../../generated/assets.dart';

class ChangeTranslateLanguage extends StatefulWidget {
  const ChangeTranslateLanguage({super.key});

  static BookLanguageModel _translationLanguage = allLanguages[0];
  static BookLanguageModel get translationLanguage => _translationLanguage;

  static final List<BookLanguageModel> allLanguages = [
    BookLanguageModel(code: "ar",id: 1),
    BookLanguageModel(code: "en", id: 2),
  ];
  @override
  State<ChangeTranslateLanguage> createState() => _ChangeTranslateLanguageState();
}

class _ChangeTranslateLanguageState extends State<ChangeTranslateLanguage> {


  late List<BookLanguageModel> languages;

  late BookLanguageModel selectedLanguage;

  @override
  void initState() {
    selectedLanguage = ChangeTranslateLanguage.allLanguages.firstWhere((e)=> e.id == ChangeTranslateLanguage._translationLanguage.id);
    languages = [...ChangeTranslateLanguage.allLanguages];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 760.h,
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
              Text(Strings.changeLanguage.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
            ],
          ),
          Gap(24.h),
          CustomTextFieldWidget(
            hint: Strings.search.tr,
            borderColor: Colors.transparent,
            backGroundColor: ThemeClass.of(context).backGroundColor,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SvgPicture.asset(Assets.imagesSearchIc,colorFilter: ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn),height: 24.r,),
            ),
            style: TextStyleHelper.of(context).s16RegTextStyle,
            onchange: (_){
              languages = ChangeTranslateLanguage.allLanguages.where((e)=> e.languageName?.toLowerCase().contains(_.toLowerCase()) ?? false).toList();
              setState(() {});
            },
          ),
          Gap(24.h),
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (_,i)=> InkWell(
                onTap: ()=> setState(() {selectedLanguage = languages[i];}),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages[i].languageName ?? "",style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: ThemeClass.of(context).primaryColor,
                      ),
                      child: Radio<BookLanguageModel>(
                        activeColor: ThemeClass.of(context).primaryColor,
                        value: languages[i],
                        groupValue: selectedLanguage,
                        onChanged: (_)=> setState(() {selectedLanguage = _!;}),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Gap(24.h),
          CustomButtonWidget.primary(
            height: 56.h,
            title: Strings.confirm.tr,
            onTap: () {
              ChangeTranslateLanguage._translationLanguage = selectedLanguage;
              context.pop();
            },
          ),
          Gap(24.h),
        ],
      ),
    );
  }
}
