import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PreviousSearchWidget extends StatelessWidget {
  const PreviousSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(16.h),
        Row(
          children: [
            Gap(24.w),
            Expanded(
                child: Text(
              Strings.previousSearch.tr,
              style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
            )),
            Icon(
              Icons.clear,
              size: 20.r,
              color: ThemeClass.of(context).mainTextColor,
            ),
            Gap(24.w),
          ],
        ),
        Gap(24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Divider(
            height: 0,
            thickness: 1.h,
            color: ThemeClass.of(context).alertBackground,
          ),
        ),
        Gap(12.h),
        Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: (){},
                    child: Row(
                      children: [
                        Expanded(child: Text("Harry Potter and the Half Blood Prin...",style: TextStyleHelper.of(context).s20SemiBoldTextStyle,)),
                        Icon(
                          Icons.clear,
                          size: 20.r,
                          color: ThemeClass.of(context).mainTextColor,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => Gap(24.h),
                itemCount: 20))
      ],
    );
  }
}
