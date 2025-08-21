import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
class SubmittedRateSuccessfullyWidget extends StatelessWidget {
  final String?bookTitle;
  final Function()?onClose;
  const SubmittedRateSuccessfullyWidget({super.key, this.bookTitle, this.onClose});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(40.h),
        SvgPicture.asset(Assets.imagesSubmittedRateSuccessfullyIc),
        Gap(32.h),
        Text(Strings.submittedSuccessfully.tr,style: TextStyleHelper.of(context).s24SemiBoldTextStyle.copyWith(
          color: ThemeClass.of(context).primaryColor
        ),),
        Gap(16.h),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 50.w),
          child: Text("${Strings.submittedSuccessfullyDes.tr} $bookTitle",style: TextStyleHelper.of(context).s16RegTextStyle,textAlign: TextAlign.center,),
        ),
        Gap(32.h),
        CustomButtonWidget.primary(
          width: 276.w,
          title: Strings.ok.tr,
          onTap:onClose?? (){
            context.pop();
            context.pop();
            },
        ),
        Gap(32.h),
      ],
    );
  }
}
