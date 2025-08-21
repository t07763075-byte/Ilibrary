import 'package:ELibrary/Modules/Auth/Register/sign_up_controller.dart';
import 'package:ELibrary/Modules/Auth/Widget/custom_check_box.dart';
import 'package:ELibrary/Modules/Auth/Widget/cutsom_linear_progress_indicator.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Utilities/validate.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/app_languages.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Widgets/phone_number_field_widget.dart';
import '../../../Widgets/custom_password_validation_widget.dart';
import '../../../Widgets/email_phone_switch_widget.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'sign-up';
  const SignUpScreen({super.key});

  @override
  createState() => _SignUpScreenState();
}

class _SignUpScreenState extends StateX<SignUpScreen> {
  _SignUpScreenState() : super(controller: SignUpController()) {
    con = SignUpController();
  }
  late SignUpController con;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LoadingScreen(
        loading: con.loading,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top,),
            SizedBox(height: 16.h,),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: PopupMenuButton<Languages>(
                elevation: 0,
                padding: EdgeInsets.zero,
                offset: Offset(0, 42.h),
                color: ThemeClass.of(context).isDark ? Colors.black : Colors.white,
                itemBuilder: (context) => <PopupMenuEntry<Languages>>[
                  PopupMenuItem<Languages>(
                    value: Languages.en,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(Assets.imagesEnFlag,width: 24.r,height: 24.r,),
                            SizedBox(width: 8.w,),
                            Text("EN",style: TextStyleHelper.of(context).s16RegTextStyle,),
                          ],
                        ),
                        SizedBox(height: 16.h,),
                        Divider(color: const Color(0xff435058),height: 0,thickness: 1.2.r,),
                      ],
                    ),
                  ),
                  PopupMenuItem<Languages>(
                    value: Languages.ar,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(Assets.imagesArFlag,width: 24.r,height: 24.r,),
                        SizedBox(width: 8.w,),
                        Text("AR",style: TextStyleHelper.of(context).s16RegTextStyle,),
                      ],
                    ),
                  ),
                ],
                onSelected: (Languages lang)=> Provider.of<AppLanguage>(context, listen: false).changeLanguage(language: lang),
                child: Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                        color: ThemeClass.of(context).primaryColor,
                        width: 2.w
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 24.r,height: 24.r,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SvgPicture.asset(
                              appLangIsArabic()? Assets.imagesArFlag : Assets.imagesEnFlag,
                              width: 24.r,height: 24.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w,),
                      Text(appLanguage(context).name.toUpperCase(),style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                      SizedBox(width: 12.w,),
                      Icon(Icons.arrow_forward_ios_rounded,color: ThemeClass.of(context).primaryColor,size: 16.r)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: ThemeClass.of(context).mainTextColor,),
                const CustomLinearProgressIndicator(value: 0.5),
                BackButton(color: ThemeClass.of(context).backGroundColor,onPressed: (){},),
              ],
            ),
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
                        AppLocalizations.of(context)?.translate(Strings.createAccount)??"",
                        style: TextStyleHelper.of(context).s32SemiBoldTextStyle,
                      ),
                      Gap(12.h),
                      Text(
                        Strings.createAccountDesc.tr,
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
                        validator: Validate.validatePassword,
                      ),
                      CustomPasswordValidationWidget(
                        passwordController: con.passwordController,
                        isFirstTimeValidate: !con.autoValidate,
                      ),

                      Gap(24.h),
                      Text(
                        Strings.confirmPassword.tr,
                        style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                      ),
                      Gap(16.h),
                      CustomTextFieldWidget(
                        underLineBorder: true,
                        style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                        controller: con.confirmPasswordController,
                        isDense: true,
                        insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                        validator: (value) => Validate.validateConfPassword(
                          newPassword: con.passwordController.text,
                          confPassword: value!,
                        ),
                        obscure: !con.isConfirmPasswordVisible,
                        suffixIcon: Icon(
                          con.isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: ThemeClass.of(context).primaryColor,
                          size: 25.r,
                        ),
                        onSuffixTap: con.toggleConfirmPasswordVisibility,
                      ),
                      Gap(24.h),
                      Row(
                        children: [
                          CustomCheckbox(
                            value: con.agreeTermsAndConditions,
                            onChanged: con.toggleTermsAndConditions,
                          ),
                          Gap(16.w),
                          RichText(
                            text: TextSpan(
                              text: Strings.iAgree.tr,
                              style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                              children: [
                                TextSpan(
                                  text: " ",
                                  style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                                ),
                                TextSpan(
                                  text: Strings.termsAndConditionsPrivacyPolicy.tr,
                                  style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
                                    color: ThemeClass.of(context).primaryColor,
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(24.h),
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
              child: CustomButtonWidget.customPrimary(
                backgroundColor: con.agreeTermsAndConditions ? ThemeClass.of(context).primaryColor : const Color(0xffC67600),
                child: Text(Strings.signUp.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                onTap: () {
                  if ((_formKey.currentState?.validate() ?? false) && con.agreeTermsAndConditions) {
                    con.register();
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
