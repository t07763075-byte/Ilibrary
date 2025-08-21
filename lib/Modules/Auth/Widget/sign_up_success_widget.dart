import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../Widgets/custom_button_widget.dart';
import '../../Home/Home/home_screen.dart';

class SignUpSuccessDialog extends StatelessWidget {
  const SignUpSuccessDialog({Key? key,}) : super(key: key);


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
          SvgPicture.asset(Assets.imagesSignUpSuccessfullIc),
          Gap(32.h),
          Text(
            Strings.signUpSuccessfull.tr,
            style: TextStyleHelper.of(context)
                .s24SemiBoldTextStyle
                .copyWith(color: ThemeClass.of(context).primaryColor),
          ),
          Gap(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Text(
              Strings.signUpSuccessfullDesc.tr,
              style: TextStyleHelper.of(context).s16RegTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Gap(32.h),
          CustomButtonWidget.primary(
            width: 276.w,
            height: 58.h,
            title: Strings.goToHome.tr,
            onTap: ()=> context.goNamed(HomeScreen.routeName),
          )
        ],
      ),
    );
  }
}
