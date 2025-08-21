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
import '../../../../Utilities/validate.dart';
import '../../../../Widgets/custom_button_widget.dart';
import '../../../../Widgets/custom_password_validation_widget.dart';
import '../../../../Widgets/custom_textfield_widget.dart';
import '../security_and_privacy_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName="changePasswordScreen";
  const ChangePasswordScreen({super.key});

  @override
   createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends StateX<ChangePasswordScreen> {
  _ChangePasswordScreenState():super(controller:SecurityAndPrivacyController() ){
    con=SecurityAndPrivacyController();

  }
  late SecurityAndPrivacyController con;

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.changePassword.tr,
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.r),
                child: Form(
                  key: _formKey,
                  autovalidateMode: con.autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      Gap(24.h),
                      Text(Strings.changePasswordMessage.tr,style: TextStyleHelper.of(context).s18RegTextStyle,),
                      Gap(32.h),
                      _CustomPasswordWidget(
                        title: Strings.currentPassword.tr,
                        controller: con.currentPasswordController,
                        obscure: con.isCurrentPasswordVisible,
                        onObscureChange: ()=> setState(()=> con.isCurrentPasswordVisible = !con.isCurrentPasswordVisible),
                      ),
                      Gap(24.h),
                      _CustomPasswordWidget(
                        title: Strings.newPassword.tr,
                        controller: con.newPasswordController,
                        obscure: con.isNewPasswordVisible,
                        onObscureChange: ()=> setState(()=> con.isNewPasswordVisible = !con.isNewPasswordVisible),
                        validator: Validate.validatePassword,
                      ),
                      CustomPasswordValidationWidget(
                        passwordController: con.newPasswordController,
                        isFirstTimeValidate: !con.autoValidate,
                      ),
                      Gap(24.h),
                      _CustomPasswordWidget(
                        title: Strings.confirmPassword.tr,
                        controller: con.confirmPasswordController,
                        obscure: con.isConfirmPasswordVisible,
                        onObscureChange: ()=> setState(()=> con.isConfirmPasswordVisible = !con.isConfirmPasswordVisible),
                      ),
                    ],
                  ),
                ),
              )
            ),
            // need
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
                title: Strings.save.tr,
                onTap: (){
                  if (_formKey.currentState?.validate() ?? false) {
                    con.changePassword();
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

class _CustomPasswordWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool obscure;
  final Function() onObscureChange;
  final String? Function(String?)? validator;
  const _CustomPasswordWidget({required this.title, required this.controller, required this.obscure, required this.onObscureChange, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
        ),
        Gap(16.h),
        CustomTextFieldWidget(
          underLineBorder: true,
          style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
          controller: controller,
          isDense: true,
          insidePadding: EdgeInsets.symmetric(vertical: 8.h),
          validator: validator,
          obscure: !obscure,
          suffixIcon: Icon(
            obscure ? Icons.visibility : Icons.visibility_off,
            color: ThemeClass.of(context).primaryColor,
            size: 25.r,
          ),
          onSuffixTap: onObscureChange,
        ),
      ],
    );
  }
}
