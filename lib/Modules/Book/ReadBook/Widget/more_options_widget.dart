import 'package:ELibrary/Modules/Book/ReadBook/read_book_provider.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../../Models/read_book_style_model.dart';
import '../../../../Widgets/custom_slider_widget.dart';

class MoreOptionsWidget extends StatelessWidget {
  const MoreOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<ReadBookProvider>(
      builder: (context,rbProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(44.r),topRight: Radius.circular(44.r)),
              border: Border(top: BorderSide(color: ThemeClass.of(context).alertBackground,),),
            color: ThemeClass.of(context).cartColor
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20.h),
                Center(
                  child: Container(height: 3.h,
                  width:38.w ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: ThemeClass.of(context).alertBackground
                  ),),
                ),
                Gap(24.h),
                Text(Strings.brightness.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
                Gap(12.h),
                CustomSliderWidget(
                  min: 0,
                  max: 100,
                  customSliderThumbCircle: CustomSliderThumbCircle(icon:Icons.sunny,),
                  value: rbProvider.styleModel.brightness.toDouble(),
                  onChanged: (b)=> rbProvider.updateStyle(rbProvider.styleModel.copyWith(brightness: b.toInt())),
                ),
                Gap(24.h),
                Text(Strings.backgroundColor.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
                Gap(12.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing:12.h,
                  children: bookBackgroundColors.mapIndexed((index,color){
                    return InkWell(
                      onTap: ()=> rbProvider.updateStyle(rbProvider.styleModel.copyWith(
                          backgroundColor: bookBackgroundColors[index],
                        fontColor: bookFontColors[index]
                      )),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        height: 60.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(width: 1.r,color: rbProvider.styleModel.backgroundColor==color?ThemeClass.of(context).primaryColor:Colors.transparent)
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Gap(24.h),
                Text(Strings.font.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
                Gap(12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing:12.h,
                  children: ReadBookFamilyTypes.values.map((font){
                    return InkWell(
                      onTap: ()=> rbProvider.updateStyle(rbProvider.styleModel.copyWith(fontFamily: font)),
                      borderRadius: BorderRadius.circular(50.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 4.h),
                        decoration: BoxDecoration(
                          color: rbProvider.styleModel.fontFamily==font?ThemeClass.of(context).primaryColor:Colors.transparent,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(width: 2.r,color: ThemeClass.of(context).primaryColor)
                        ),
                        child: Text(font.name,style: TextStyleHelper.of(context).s14SemiBoldTextStyle.copyWith(
                          color:rbProvider.styleModel.fontFamily==font?ThemeClass.of(context).mainTextColor: ThemeClass.of(context).primaryColor,

                        ),),
                      ),
                    );
                  }).toList(),
                ),
                Gap(24.h),
                Text(Strings.fontSize.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
                Gap(12.h),
                CustomSliderWidget(
                  min: 0.75,
                  max: 1.75,
                  customSliderThumbCircle: CustomSliderThumbCircle(text: "${(rbProvider.styleModel.fontSizeFactor * 100).toInt()}%",),
                  value: rbProvider.styleModel.fontSizeFactor,
                  onChanged: (factor)=> rbProvider.updateStyle(rbProvider.styleModel.copyWith(fontSizeFactor: factor)),
                ),
                Gap(64.h),
              ],
            ),
          ),
        );
      }
    );
  }

}
