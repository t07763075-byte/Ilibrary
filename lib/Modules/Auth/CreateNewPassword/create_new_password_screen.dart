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
import '../../../Widgets/custom_password_validation_widget.dart';
import 'create_new_password_controller.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  static const String routeName = 'createNewPasswordScreen';

  final String emailOrPhone;
  final String? countryCode;
  const CreateNewPasswordScreen({super.key, required this.emailOrPhone, this.countryCode});

  @override
  createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends StateX<CreateNewPasswordScreen> {
  _CreateNewPasswordScreenState() : super(controller: CreateNewPasswordController()) {
    con = CreateNewPasswordController();
  }

  late CreateNewPasswordController con;
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
                  autovalidateMode: con.autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.createNewPassword.tr,
                        style: TextStyleHelper.of(context).s32SemiBoldTextStyle,
                      ),
                      Gap(12.h),
                      Text(
                        Strings.createNewPasswordMessage.tr,
                        style: TextStyleHelper.of(context).s18RegTextStyle,
                      ),
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
                        validator: Validate.validatePassword,
                        obscure: !con.passwordVisible,
                        suffixIcon: Icon(
                          con.passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: ThemeClass.of(context).primaryColor,
                          size: 24.r,
                        ),
                        onSuffixTap: ()=> setState(()=> con.passwordVisible = !con.passwordVisible),
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
                        obscure: !con.confirmPasswordVisible,
                        suffixIcon: Icon(
                          con.confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: ThemeClass.of(context).primaryColor,
                          size: 24.r,
                        ),
                        onSuffixTap: ()=> setState(()=> con.confirmPasswordVisible = !con.confirmPasswordVisible),
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
                title: Strings.confirm.tr,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    con.confirm(emailOrPhone: widget.emailOrPhone,countryCode: widget.countryCode);
                  }else{
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
