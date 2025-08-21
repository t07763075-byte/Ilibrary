import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../Utilities/format_date_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../generated/assets.dart';

class SubscriptionDetailsWidget extends StatelessWidget {
  const SubscriptionDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
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
        Row(
          children: [
            Gap(24.w),
            Text(Strings.subscriptionDetails.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
          ],
        ),
        Gap(24.h),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SvgPicture.asset(Assets.imagesMySubscriptionCardIc),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                            "Annual",
                            style:
                            TextStyleHelper.of(context).s14SemiBoldTextStyle,
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 9.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            color: ThemeClass.of(context).warningColor,
                            borderRadius: BorderRadius.circular(16.r)),
                        child: Text(
                          "Best Value",
                          style: TextStyleHelper.of(context).s10SemiBoldTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "First 30 days free - Then 999/Year",
                    style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
        Gap(16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: ThemeClass.of(context).backGroundColor
          ),
          child: Column(
            children: [
              Text("iLibrary annual plan gives you unlimited books to read and words, notes, highlights to save, it’s the best value.",style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                height: 1.5
              ),),
              Gap(35.h),
              Row(
                children: [
                  Text(Strings.month.tr,style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                    color: ThemeClass.of(context).lightGreyColor
                  ),),
                  const Spacer(),
                  Text("March",style: TextStyleHelper.of(context).s14RegTextStyle,),
                ],
              ),
              Gap(24.h),
              Row(
                children: [
                  Text(Strings.amount.tr,style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                    color: ThemeClass.of(context).lightGreyColor
                  ),),
                  const Spacer(),
                  Text("\$999/Year",style: TextStyleHelper.of(context).s14RegTextStyle,),
                ],
              ),
              Gap(24.h),
              Row(
                children: [
                  Text(Strings.begins.tr,style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                    color: ThemeClass.of(context).lightGreyColor
                  ),),
                  const Spacer(),
                  Text(FormatDateHelper.formatDateSubscriptionDetails.format(DateTime.now()),style: TextStyleHelper.of(context).s14RegTextStyle,),
                ],
              ),
              Gap(24.h),
              Row(
                children: [
                  Text(Strings.ends.tr,style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                    color: ThemeClass.of(context).lightGreyColor
                  ),),
                  const Spacer(),
                  Text(FormatDateHelper.formatDateSubscriptionDetails.format(DateTime.now()),style: TextStyleHelper.of(context).s14RegTextStyle,),
                ],
              ),
              Gap(24.h),
              Row(
                children: [
                  Text(Strings.type.tr,style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                      color: ThemeClass.of(context).lightGreyColor
                  ),),
                  const Spacer(),
                  Text("Annual",style: TextStyleHelper.of(context).s14RegTextStyle,),
                ],
              ),
            ],
          ),
        ),
        Gap(24.h),
        CustomButtonWidget.customPrimary(
          width: 382.w,
          backgroundColor: ThemeClass.of(context).warningColor,
          child: Text(Strings.cancelSubscription.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),

        ),
        Gap(32.h),
      ],
    );
  }
}
