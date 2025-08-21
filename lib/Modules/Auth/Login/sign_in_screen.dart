import 'package:ELibrary/Modules/Auth/ForgotPassword/forgot_password_screen.dart';
import 'package:ELibrary/Modules/Auth/Login/sign_in_controller.dart';
import 'package:ELibrary/Modules/Auth/Widget/custom_check_box.dart';
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
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Widgets/phone_number_field_widget.dart';
import '../../../Widgets/email_phone_switch_widget.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = 'SignInScreen';
  const SignInScreen({super.key});

  @override
  createState() => _SignInScreenState();
}

class _SignInScreenState extends StateX<SignInScreen> {
  _SignInScreenState() : super(controller: SignInController()) {
    con = SignInController();
  }

  late SignInController con;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
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
                  autovalidateMode: con.autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.helloThere.tr,
                        style: TextStyleHelper.of(context).s32SemiBoldTextStyle,
                      ),
                      Gap(12.h),
                      SizedBox(
                        height: 48.h,
                        child: Text(
                          con.isSelectEmail? Strings.enterEmailAndPassword.tr : Strings.enterPhoneAndPassword.tr,
                          style: TextStyleHelper.of(context).s18RegTextStyle,
                        ),
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
                      Gap(24.h),
                      Text(
                        Strings.password.tr,
                        style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                      ),
                      Gap(16.h),
                      CustomTextFieldWidget(
                        underLineBorder: true,
                        style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                        controller: con.passwordController,
                        isDense: true,
                        insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                        obscure: !con.isPasswordVisible,
                        suffixIcon: Icon(
                          con.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: ThemeClass.of(context).primaryColor,
                          size: 25.r,
                        ),
                        onSuffixTap: con.togglePasswordVisibility,
                      ),
                      Gap(24.h),
                      Row(
                        children: [
                          CustomCheckbox(
                            value: con.isRememberMe,
                            onChanged: con.toggleRememberMe,
                          ),
                          Gap(16.w),
                          Text(
                            Strings.rememberMe.tr,
                            style:
                                TextStyleHelper.of(context).s18SemiBoldTextStyle,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: ()=> context.pushNamed(ForgotPasswordScreen.routeName),
                            child: Text(
                              Strings.forgotPassword.tr,
                              style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
                                color: ThemeClass.of(context).primaryColor,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          )
                        ],
                      ),
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
                title: Strings.signIn.tr,
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    con.login();
                  } else {
                    setState(() {
                      con.autoValidate = true;
                    });
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
