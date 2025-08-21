import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Utilities/validate.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Widgets/phone_number_field_widget.dart';
import '../../../Widgets/email_phone_switch_widget.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = 'forgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends StateX<ForgotPasswordScreen> {
  _ForgotPasswordScreenState() : super(controller: ForgotPasswordController()) {
    con = ForgotPasswordController();
  }

  late ForgotPasswordController con;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget.detailsScreen(),
      resizeToAvoidBottomInset: true,
      body: LoadingScreen(
        loading: con.loading,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.r),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Strings.forgotPassword.tr.replaceAll("?", "")} 🔑",
                        style: TextStyleHelper.of(context).s32SemiBoldTextStyle,
                      ),
                      Gap(12.h),
                      Text(
                        Strings.forgotPasswordMessage.tr,
                        style: TextStyleHelper.of(context).s18RegTextStyle,
                      ),
                      Gap(24.h),
                      EmailPhoneSwitchWidget(
                        initSelectEmail: con.isSelectEmail,
                        onChange: (_) {
                          setState(()=> con.isSelectEmail = _);
                          WidgetsBinding.instance.addPostFrameCallback((_)=>setState((){}));
                          if(con.isSelectEmail) con.phoneNumberController.clear();
                          if(!con.isSelectEmail) con.emailController.clear();
                        },
                      ),
                      Gap(24.h),
                      if(!con.isSelectEmail) Text(
                        Strings.phoneNumber.tr,
                        style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                      ),
                      if(!con.isSelectEmail) Gap(16.h),
                      if(!con.isSelectEmail) CustomTextFieldWidget(
                        textInputType: TextInputType.phone,
                        prefixIcon: PhoneNumberFieldWidget(
                          initCountryDialCode: con.phoneCountryCode,
                          onCountryCodeChange: (_)=> con.phoneCountryCode = _.dialCode ?? "",
                        ),
                        underLineBorder: true,
                        style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                        controller: con.phoneNumberController,
                        isDense: true,
                        insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                        validator: Validate.validatePhoneNumber,
                      ),
                      if(!con.isSelectEmail) Gap(24.h),
                      if(con.isSelectEmail) Text(
                        Strings.email.tr,
                        style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                      ),
                      if(con.isSelectEmail) Gap(16.h),
                      if(con.isSelectEmail) CustomTextFieldWidget(
                        underLineBorder: true,
                        style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                        controller: con.emailController,
                        textInputType: TextInputType.emailAddress,
                        isDense: true,
                        insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                        validator: Validate.validateEmail,
                      ),
                      if(con.isSelectEmail) Gap(24.h),
                    ],
                  ),
                ),
              ),
            ),
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
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    con.onSendOtp();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
