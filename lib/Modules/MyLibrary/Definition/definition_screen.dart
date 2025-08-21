import 'package:ELibrary/Models/definition_model.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import 'definition_controller.dart';

class DefinitionScreen extends StatefulWidget {
  static const routeName = "Definition";
  final DefinitionModel definition;

  const DefinitionScreen({super.key, required this.definition});

  @override
  createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends StateX<DefinitionScreen> {
  _DefinitionScreenState() : super(controller:DefinitionController() ) {
    con = DefinitionController();
  }

  late DefinitionController con;

  @override
  void initState() {
    con.definition = widget.definition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: "${Strings.definitionOf.tr} ${con.definition?.word}",
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                    color: ThemeClass.of(context).cartColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                        width: 1.r, color: ThemeClass.of(context).borderColor)),
                child: RawScrollbar(
                  thumbVisibility: true,
                  thickness: 4.w,
                  radius: Radius.circular(4.r),
                  thumbColor: ThemeClass.of(context).primaryColor,
                  child: ListView(
                    children: [
                      ...con.definition!.definitions.map((e) {
                        return Text(
                          e,
                          style: TextStyleHelper.of(context)
                              .s16SemiBoldTextStyle
                              .copyWith(height: 1.6),
                        );
                      }).toList(),
                      if (con.definition!.examples.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(24.h),
                            Text(
                              Strings.phraseExample.tr,
                              style: TextStyleHelper.of(context)
                                  .s16SemiBoldTextStyle,
                            ),
                            Gap(16.h),
                            ...con.definition!.examples.map((e) {
                              return Text(
                                e,
                                style: TextStyleHelper.of(context)
                                    .s16SemiBoldTextStyle
                                    .copyWith(
                                        height: 1.4,
                                        color:
                                            ThemeClass.of(context).primaryColor),
                              );
                            }).toList(),
                          ],
                        ),
                      if (con.definition!.synonyms.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(24.h),
                            Text(
                              Strings.synonyms.tr,
                              style: TextStyleHelper.of(context)
                                  .s16SemiBoldTextStyle,
                            ),
                            Gap(16.h),
                            ...con.definition!.synonyms.map((e) {
                              return Row(

                                children: [
                                  Icon(Icons.circle,
                                      size: 3.r,
                                      color: ThemeClass.of(context).primaryColor),
                                  Gap(8.w),
                                  Text(
                                    e,
                                    style: TextStyleHelper.of(context)
                                        .s16SemiBoldTextStyle
                                        .copyWith(
                                            color: ThemeClass.of(context)
                                                .primaryColor,
                                            height: 1.5),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      if (con.definition!.antonyms.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(24.h),
                            Text(
                              Strings.antonyms.tr,
                              style: TextStyleHelper.of(context)
                                  .s16SemiBoldTextStyle,
                            ),
                            Gap(16.h),
                            ...con.definition!.antonyms.map((e) {
                              return Row(
                                children: [
                                  Icon(Icons.circle,
                                      size: 3.r,
                                      color: ThemeClass.of(context).primaryColor),
                                  Gap(8.w),
                                  Expanded(
                                    child: Text(
                                      e,
                                      style: TextStyleHelper.of(context)
                                          .s16SemiBoldTextStyle
                                          .copyWith(
                                              color: ThemeClass.of(context)
                                                  .primaryColor,
                                              height: 1.5),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                    ],
                  ),
                ),
              )),
              Gap(24.h),
              CustomButtonWidget.customPrimary(
                radius: 100.r,
                backgroundColor: ThemeClass.of(context).warningColor,
                onTap:()=> con.deleteWord(),
                child: Text(
                  Strings.deleteWord.tr,
                  style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                ),
              ),
              Gap(62.h),
            ],
          ),
        ),
      ),
    );
  }
}
