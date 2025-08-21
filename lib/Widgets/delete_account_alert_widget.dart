import 'package:ELibrary/Modules/Account/SecurityAndPrivacy/Screens/delete_my_account_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../Utilities/strings.dart';
import '../Utilities/text_style_helper.dart';
import '../Utilities/theme_helper.dart';
import 'custom_button_widget.dart';

class DeleteAccountAlertWidget extends StatelessWidget {
  const DeleteAccountAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(44.r),topRight: Radius.circular(44.r)),
        color: ThemeClass.of(context).cartColor,
        border: Border(
          top: BorderSide(color: ThemeClass.of(context).alertBackground,),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(8.h),
          Center(
            child: Container(
              height: 3.h,
              width: 40.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: ThemeClass.of(context).alertBackground
              ),
            ),
          ),
          Gap(16.h),
          Center(
            child: Text(
              Strings.deleteYourAccount.tr,
              style: TextStyleHelper.of(context).s24SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).warningColor),
            ),
          ),
          Gap(16.h),
          Container(
            height: 1.2.r,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: ThemeClass.of(context).alertBackground
            ),
          ),
          Gap(16.h),
          Text(Strings.deleteAccountWarningTitle.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle.copyWith(height: 1.3),),
          Text(Strings.deleteAccountWarningInfo.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle.copyWith(height: 1.3),),
          Gap(16.h),
          Text(Strings.deleteAccountConsequencesTitle.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle.copyWith(height: 1.6),),
          Gap(8.h),
          Text(Strings.deleteAccountConsequencesDetails.tr,style: TextStyleHelper.of(context).s18RegTextStyle.copyWith(height: 1.4),),
          Gap(8.h),
          Text(Strings.deleteAccountIrreversibleNotice.tr,style: TextStyleHelper.of(context).s18RegTextStyle.copyWith(height: 1.4),),
          Gap(24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButtonWidget.secondary(
                width: 185.w,
                height: 56.h,
                title: Strings.cancel.tr,
                onTap: ()=> context.pop(),
              ),
              CustomButtonWidget.customPrimary(
                width: 185.w,
                height: 56.h,
                backgroundColor: ThemeClass.of(context).warningColor,
                child: Text(Strings.deleteMyAccount.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                onTap: ()=> context.pushNamed(DeleteMyAccountScreen.routeName),
              ),
            ],
          ),
          Gap(24.h),
        ],
      ),
    );
  }
}
