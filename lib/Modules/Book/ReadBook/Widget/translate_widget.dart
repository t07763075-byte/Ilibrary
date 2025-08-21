import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../Utilities/bottom_sheet_helper.dart';
import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Utilities/toast_helper.dart';
import '../ReadBookDataHandler/manager_data_handler.dart';
import 'change_translate_language.dart';

class TranslateWidget extends StatefulWidget {
  final String selectedText;
  const TranslateWidget({super.key, required this.selectedText});

  @override
  State<TranslateWidget> createState() => _TranslateWidgetState();
}

class _TranslateWidgetState extends State<TranslateWidget> {

  bool loading = false;
  String translatedText = "";
  int lastTranslationLanguageId = 0;

  Future translate()async{
    lastTranslationLanguageId = ChangeTranslateLanguage.translationLanguage.id ?? 0;
    setState(() {loading = true;});
    final result = await ReadBookDataHandlerManage.translate(selectedText: widget.selectedText,translateInto: ChangeTranslateLanguage.translationLanguage.id ?? 0);
    result.fold((l)=> ToastHelper.showError(message: l.message), (r)=> translatedText = r);
    setState(() {loading = false;});
  }


  @override
  void initState() {
    translate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  LoadingScreen(
      loading: loading,
      child: Container(
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
              Text(Strings.translate.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
              Gap(24.h),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 120.h,
                  maxHeight: 360.h,
                  minWidth: double.infinity,
                  maxWidth: double.infinity
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: ThemeClass.of(context).borderColor,)
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Text(widget.selectedText,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                ),
              ),
              Gap(24.h),
              InkWell(
                onTap: () {
                  BottomSheetHelper.bottomSheet(
                    context: context,
                    widget: const ChangeTranslateLanguage(),
                    onDismiss: (){
                      if(ChangeTranslateLanguage.translationLanguage.id != lastTranslationLanguageId) translate();
                    }
                  );
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: ThemeClass.of(context).primaryColor,),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ChangeTranslateLanguage.translationLanguage.languageName ?? "",
                        style: TextStyleHelper.of(context).s16RegTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),),
                      Icon(Icons.arrow_forward_ios,color: ThemeClass.of(context).primaryColor,size: 18.r,),
                    ],
                  ),
                ),
              ),
              Gap(24.h),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 120.h,
                    maxHeight: 360.h,
                    minWidth: double.infinity,
                    maxWidth: double.infinity
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: ThemeClass.of(context).borderColor,)
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Text(translatedText,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                ),
              ),
              Gap(12.h),
            ],
          ),
        ),
      ),
    );
  }
}
