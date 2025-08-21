import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utilities/theme_helper.dart';

class FilterWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final double? height;
  final bool isTitleTranslated;
  const FilterWidget({super.key, required this.title,  required this.isSelected, this.height, this.isTitleTranslated = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: height != null? Alignment.center: null,
      padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: height != null? 0: 10.h),
      decoration: BoxDecoration(
        color: isSelected? ThemeClass.of(context).primaryColor:Colors.transparent,
          border: Border.all(width: 1.r,color: ThemeClass.of(context).primaryColor),
        borderRadius: BorderRadius.circular(100.r)
      ),
      child: Text(isTitleTranslated? title : title.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
        color:isSelected? ThemeClass.of(context).mainTextColor:ThemeClass.of(context).primaryColor
      ),),
    );
  }
}
