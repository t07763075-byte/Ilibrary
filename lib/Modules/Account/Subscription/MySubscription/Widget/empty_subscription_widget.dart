import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../my_subscription_controller.dart';
class EmptySubscriptionWidget extends StatelessWidget {
  const EmptySubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Gap(64.h),
        SvgPicture.asset(Assets.imagesEmptySubscriptionIc),
        Gap(24.h),
        Text(Strings.notSubscribed.tr,style: TextStyleHelper.of(context).s24SemiBoldTextStyle,),
        Gap(12.h),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(Strings.notSubscribedDes.tr,style: TextStyleHelper.of(context).s14RegTextStyle,textAlign: TextAlign.center,),
        ),
        Gap(32.h),
        CustomButtonWidget.primary(
          width: 382.w,
          title: Strings.subscribeNow.tr,
          onTap: MySubscriptionController().subscriptionPlanWidget,
        )
      ],
    );
  }
}
