import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../Utilities/strings.dart';
import '../Utilities/text_style_helper.dart';
import '../Utilities/theme_helper.dart';
import '../generated/assets.dart';
import 'custom_button_widget.dart';
class DeleteSuccessfullyWidget extends StatelessWidget {
  final String message;
  final Function()?onBack;
  const DeleteSuccessfullyWidget({super.key, required this.message, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(40.h),
        SvgPicture.asset(Assets.imagesSubmittedRateSuccessfullyIc),
        Gap(32.h),
        Text(Strings.deletedSuccessfully.tr,style: TextStyleHelper.of(context).s24SemiBoldTextStyle.copyWith(
            color: ThemeClass.of(context).primaryColor
        ),),
        Gap(16.h),
        Text(message,style: TextStyleHelper.of(context).s16RegTextStyle,textAlign: TextAlign.center,),
        Gap(32.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonWidget.primary(
              width: 276.w,
              title: Strings.ok.tr,
              onTap:onBack?? (){
                context.pop();
                },
            ),
          ],
        ),
        Gap(32.h),
      ],
    );
  }
}
