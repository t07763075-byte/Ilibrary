
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

class NoInternetConnectionWidget extends StatelessWidget {
  final Function()? onTryAgain;
  const NoInternetConnectionWidget({super.key, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: ThemeClass.of(context).cartColor
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.imagesNoInternet,height: 75.r,width: 75.r,),
          Gap(32.h),
          Text(Strings.noInternetConnectionMessage.tr,style: TextStyleHelper.of(context).s16RegTextStyle,textAlign: TextAlign.center,),
          Gap(28.h),
          CustomButtonWidget.primary(
            enableAnimated: true,
            height: 58.h,
            title: Strings.tryAgain.tr,
            onTap: onTryAgain,
          ),
        ],
      ),
    );
  }
}
