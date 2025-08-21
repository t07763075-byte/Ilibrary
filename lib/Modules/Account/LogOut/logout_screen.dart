import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Utilities/theme_helper.dart';
import 'logout_controller.dart';
class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
   createState() => _LogoutScreenState();
}

class _LogoutScreenState extends StateX<LogoutScreen> {
  _LogoutScreenState():super(controller: LogoutController()){
    con=LogoutController();

  }
  late LogoutController con;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Text(Strings.logout.tr,style: TextStyleHelper.of(context).s24SemiBoldTextStyle.copyWith(
            color: ThemeClass.of(context).warningColor
          ),),
          Divider(
            height: 48.h,
            color: ThemeClass.of(context).alertBackground,
            thickness: 1.h,
          ),
          Text(Strings.logoutDes.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle),
          Gap(24.h),
          Row(
            children: [
              Expanded(
                child: CustomButtonWidget.secondary(
                  title: Strings.cancel.tr,
                  onTap: context.pop,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: CustomButtonWidget.primary(
                  title: Strings.yesLogout.tr,
                  onTap: LogoutController.logOut,
                ),
              ),
            ],
          ),
          Gap(36.h)
        ],
      ),
    );
  }
}
