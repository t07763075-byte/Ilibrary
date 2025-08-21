import 'package:ELibrary/Modules/Auth/Login/sign_in_screen.dart';
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

class ResetPasswordSuccessWidget extends StatelessWidget {
  const ResetPasswordSuccessWidget({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: ThemeClass.of(context).cartColor,
      ),
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(40.h),
          SvgPicture.asset(Assets.imagesResetPasswordSuccess),
          Gap(32.h),
          Text(
            Strings.resetPasswordSuccess.tr,
            style: TextStyleHelper.of(context).s24SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),
          ),
          Gap(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Text(
              Strings.resetPasswordSuccessMessage.tr,
              style: TextStyleHelper.of(context).s16RegTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Gap(32.h),
          CustomButtonWidget.primary(
            width: 276.w,
            height: 58.h,
            title: Strings.signIn.tr,
            onTap: ()=> context.pushNamed(SignInScreen.routeName),
          )
        ],
      ),
    );
  }
}
