import 'package:ELibrary/Models/language_model.dart';
import 'package:ELibrary/Utilities/git_it.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Utilities/enum.dart';
import '../../../Widgets/filter_widget.dart';
import 'filter_controller.dart';
class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
   createState() => _FilterScreenState();
}

class _FilterScreenState extends StateX<FilterScreen> {
  _FilterScreenState():super(controller: FilterController()){
    con=FilterController();
  }
  late FilterController con;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: ThemeClass.of(context).mainTextColor,
        ),
        child: Column(
          children: [
            Gap(65.h),
            Row(
              children: [
                Gap(24.w),
                InkWell(
                  onTap:() {
                    con.onReset();
                    context.pop();
                  },
                    child: Icon(Icons.close,color: ThemeClass.of(context).mainTextColor,size: 28.r,)),
                Gap(16.w),
                Text(Strings.filter.tr,style: TextStyleHelper.of(context).s24SemiBoldTextStyle,),
              ],
            ),
            Gap(24.h),
            SizedBox(
              height: 38.h,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        con.selectedFilter = GeneralFilterType.values[index];
                      }),
                      child: FilterWidget(
                         title: GeneralFilterType.values[index].name,
                        isSelected:con.selectedFilter== GeneralFilterType.values[index],
                        height: 38.h,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => Gap(8.w),
                  itemCount:GeneralFilterType.values.length),
            ),
            Gap(24.h),
            Expanded(child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
              children: [
               if(con.selectedFilter==GeneralFilterType.sort) Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: ThemeClass.of(context).cartColor,
                    border: Border.all(width: 1.r,color: ThemeClass.of(context).alertBackground),
                    borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Strings.sort.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),


                      ...SortType.values.map((sort){
                        return Column(
                          children: [
                            Gap(16.h),
                            Divider(
                              height: 0,
                              thickness: 1.h,
                              color: ThemeClass.of(context).alertBackground,
                            ),
                            Gap(16.h),
                            InkWell(
                              onTap: (){
                                con.selectedSort=sort;
                                setState((){});
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24.r,
                                    height: 24.r,
                                    child: Radio<SortType>(
                                      value: sort,
                                      activeColor: ThemeClass.of(context).primaryColor,
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,
                                      groupValue: con.selectedSort,
                                      onChanged: (SortType? value) {
                                        con.selectedSort=value!;
                                        setState((){});
                                      },
                                    ),
                                  ),
                                  Gap(16.w),
                                  Text(sort.name.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,)
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList()
                    ],
                  ),
                ),
               if(con.selectedFilter==GeneralFilterType.language) Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: ThemeClass.of(context).cartColor,
                    border: Border.all(width: 1.r,color: ThemeClass.of(context).alertBackground),
                    borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Strings.language.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),
                      ...GitIt.language.map((lang){
                        return Column(
                          children: [
                            Gap(16.h),
                            Divider(
                              height: 0,
                              thickness: 1.h,
                              color: ThemeClass.of(context).alertBackground,
                            ),
                            Gap(16.h),
                            InkWell(
                              onTap: (){
                                con.selectedLanguage=lang;
                                setState((){});
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24.r,
                                    height: 24.r,
                                    child: Radio<LanguageModel>(
                                      value: lang,
                                      activeColor: ThemeClass.of(context).primaryColor,
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,
                                      groupValue: con.selectedLanguage,
                                      onChanged: (LanguageModel? value) {
                                        con.selectedLanguage=value!;
                                        setState((){});
                                      },
                                    ),
                                  ),
                                  Gap(16.w),
                                  Text(lang.name??'',style: TextStyleHelper.of(context).s18SemiBoldTextStyle,)
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList()
                    ],
                  ),
                ),
                if(con.selectedFilter==GeneralFilterType.rating) Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: ThemeClass.of(context).cartColor,
                    border: Border.all(width: 1.r,color: ThemeClass.of(context).alertBackground),
                    borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Strings.rating.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),


                      ...RatingType.values.map((rating){
                        return Column(
                          children: [
                            Gap(16.h),
                            Divider(
                              height: 0,
                              thickness: 1.h,
                              color: ThemeClass.of(context).alertBackground,
                            ),
                            Gap(16.h),
                            InkWell(
                              onTap: (){
                                con.selectedRating=rating;
                                setState((){});
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24.r,
                                    height: 24.r,
                                    child: Radio<RatingType>(
                                      value: rating,
                                      activeColor: ThemeClass.of(context).primaryColor,
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,
                                      groupValue: con.selectedRating,
                                      onChanged: (RatingType? value) {
                                        con.selectedRating=value!;
                                        setState((){});
                                      },
                                    ),
                                  ),
                                  Gap(16.w),
                                  Text(rating.name.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,)
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList()
                    ],
                  ),
                ),
              ],
            )),
            Column(
              children: [
                Divider(
                  height: 0,
                  color: ThemeClass.of(context).alertBackground,
                  thickness: 1.h,
                ),
                Gap(24.h),
                Row(
                  children: [
                    Gap(24.w),
                    Expanded(child: CustomButtonWidget.secondary(
                      onTap: con.onReset,
                      title: Strings.reset.tr,
                    )),
                    Gap(16.w),
                    Expanded(child: CustomButtonWidget.primary(
                      title: Strings.apply.tr,
                      onTap: con.onApply,
                    )),
                    Gap(24.w),
                  ],
                ),
                Gap(36.h),
              ],
            )
          ],
        ),
      ),
    );
  }
}
