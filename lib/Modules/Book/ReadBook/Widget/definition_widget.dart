import 'package:ELibrary/Models/language_model.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../Models/definition_model.dart';
import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Widgets/custom_button_widget.dart';
import '../ReadBookDataHandler/manager_data_handler.dart';

class DefinitionWidget extends StatefulWidget {
  final int bookId;
  final String selectedWord;
  final Function(DefinitionModel) onSave;
  const DefinitionWidget({super.key,required this.bookId, required this.selectedWord, required this.onSave});

  @override
  State<DefinitionWidget> createState() => _DefinitionWidgetState();
}

class _DefinitionWidgetState extends State<DefinitionWidget> {
  DefinitionModel? definition;
  bool isNotFound = false;
  LanguageModel? selectedLanguage;

  Future<void> getDefinition()async{
    final result = await ReadBookDataHandlerManage.definition(
      bookId: widget.bookId,
      selectedText: widget.selectedWord,
      languageId: selectedLanguage?.id
    );
    result.fold(
      (l) => setState(() => isNotFound = true),
      (r) => setState(() => definition = r),
    );
  }

  void onSelectLanguage(LanguageModel language) {
    setState(() => selectedLanguage = language);
    getDefinition();
  }

  @override
  Widget build(BuildContext context) {
    if(selectedLanguage == null) return SelectDefinitionLanguage(onSelectLanguage: onSelectLanguage);
    if(isNotFound) return const DefinitionNotFoundWidget();
    if(definition == null) return const LoadingDefinitionWidget();
    return  _DefinitionWidget(
      definition: definition!,
      onSave: ()=> widget.onSave(definition!),
    );
  }
}

class _DefinitionWidget extends StatelessWidget {
  final DefinitionModel definition;
  final Function() onSave;

  const _DefinitionWidget({required this.definition, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text("${Strings.definitionOf.tr}  '${definition.word}'",style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
            Gap(24.h),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 360.h,
                  maxHeight: 480.h,
                  minWidth: double.infinity,
                  maxWidth: double.infinity
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: ThemeClass.of(context).borderColor,)
                ),
                padding: EdgeInsets.all(12.r),
                child:RawScrollbar(
                  thumbVisibility: true,
                  thickness: 4.w,
                  radius: Radius.circular(4.r),
                  thumbColor: ThemeClass.of(context).primaryColor,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if(definition.partOfSpeech != null) Text(definition.partOfSpeech!,style: TextStyleHelper.of(context).s22SemiBoldTextStyle,),

                      if(definition.definitions.isNotEmpty) Gap(16.h),
                      ...definition.definitions.map((e)=> Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Text("- $e",style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                      )).toList(),

                      if(definition.examples.isNotEmpty) Gap(16.h),
                      if(definition.examples.isNotEmpty) Text(Strings.phraseExample.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),
                      if(definition.examples.isNotEmpty) Gap(16.h),
                      ...definition.examples.map((e)=> Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Text("● $e",style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),),
                      )).toList(),

                      if(definition.synonyms.isNotEmpty) Gap(16.h),
                      if(definition.synonyms.isNotEmpty) Text(Strings.synonyms.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),
                      if(definition.synonyms.isNotEmpty) Gap(16.h),
                      ...definition.synonyms.map((e)=> Text("● $e",style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),)).toList(),
                      if(definition.antonyms.isNotEmpty) Gap(16.h),
                      if(definition.antonyms.isNotEmpty) Text(Strings.antonyms.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),
                      if(definition.antonyms.isNotEmpty) Gap(16.h),
                      ...definition.antonyms.map((e)=> Text("● $e",style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),)).toList(),

                    ],
                  ),
                ),
              ),
            ),
            Gap(24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonWidget.secondary(
                  height: 56.h,
                  width: 185.w,
                  title: Strings.cancel.tr,
                  onTap: ()=> context.pop(),
                ),
                CustomButtonWidget.primary(
                  height: 56.h,
                  width: 185.w,
                  title: Strings.save.tr,
                  onTap: () {
                    context.pop();
                    onSave();
                  },
                ),
              ],
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}


class LoadingDefinitionWidget extends StatelessWidget {
  const LoadingDefinitionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(44.r),topRight: Radius.circular(44.r)),
          border: Border(
            top: BorderSide(color: ThemeClass.of(context).alertBackground,),
          ),
          color: ThemeClass.of(context).cartColor
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Strings.gettingDefinition.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
          Gap(8.w),
          // Image.asset(Assets.imagesDotsLoader,),
          Lottie.asset(Assets.imagesLottieLoading),
        ],
      ),
    );
  }
}

class DefinitionNotFoundWidget extends StatelessWidget {
  const DefinitionNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 48.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(44.r),topRight: Radius.circular(44.r)),
          border: Border(
            top: BorderSide(color: ThemeClass.of(context).alertBackground,),
          ),
          color: ThemeClass.of(context).cartColor
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.imagesNoBookIc),
          Gap(16.h),
          Text(Strings.definitionNotFound.tr,style: TextStyleHelper.of(context).s16RegTextStyle,),
        ],
      ),
    );
  }
}

class SelectDefinitionLanguage extends StatefulWidget {
  final void Function(LanguageModel language) onSelectLanguage;
  const SelectDefinitionLanguage({super.key, required this.onSelectLanguage});

  @override
  State<SelectDefinitionLanguage> createState() => _SelectDefinitionLanguageState();
}

class _SelectDefinitionLanguageState extends State<SelectDefinitionLanguage> {

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
