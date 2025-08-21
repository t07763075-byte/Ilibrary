import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import '../../../../Widgets/custom_button_widget.dart';
import '../../../../Widgets/custom_textfield_widget.dart';
import '../security_and_privacy_controller.dart';

class ChangeEmailScreen extends StatefulWidget {
  static const routeName="changeEmailScreen";
  const ChangeEmailScreen({super.key});

  @override
   createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends StateX<ChangeEmailScreen> {
  _ChangeEmailScreenState():super(controller:SecurityAndPrivacyController() ){
    con=SecurityAndPrivacyController();

  }
  late SecurityAndPrivacyController con;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.changeEmail.tr,
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(32.h),
              Text(Strings.enterNewEmailMessage.tr,style: TextStyleHelper.of(context).s18RegTextStyle,),
              Gap(24.h),
              Text(
                Strings.email.tr,
                style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
              ),
              Gap(16.h),
              CustomTextFieldWidget(
                underLineBorder: true,
                style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                controller: con.emailController,
                textInputType: TextInputType.emailAddress,
                isDense: true,
                insidePadding: EdgeInsets.symmetric(vertical: 8.h),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: ThemeClass.of(context).backGroundColor,
                  border: Border(
                    top: BorderSide(
                      color: ThemeClass.of(context).alertBackground,
                    ),
                  ),
                ),
                child: CustomButtonWidget.primary(
                  title: Strings.continuee.tr,
                  onTap: con.changeEmail,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}