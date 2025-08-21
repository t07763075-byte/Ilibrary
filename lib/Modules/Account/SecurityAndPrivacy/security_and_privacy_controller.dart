import 'dart:async';
import 'package:ELibrary/Modules/Account/SecurityAndPrivacy/security_and_privacy_data_handler.dart';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:ELibrary/Utilities/validate.dart';
import 'package:ELibrary/Widgets/delete_account_success_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/dialog_helper.dart';
import '../../../Utilities/router_config.dart';
import '../../../Widgets/change_email_success_widget.dart';
import '../../../Widgets/change_password_success_widget.dart';
import '../../../Widgets/change_phone_number_success_widget.dart';
import '../../Auth/OtpCode/otp_code_data_handler.dart';
import '../../Auth/OtpCode/otp_code_screen.dart';
import '../LogOut/logout_controller.dart';

class SecurityAndPrivacyController extends StateXController {
  // singleton
  factory SecurityAndPrivacyController() => _this ??= SecurityAndPrivacyController._();
  static SecurityAndPrivacyController? _this;

  SecurityAndPrivacyController._();

  bool loading = false, autoValidate = false,isPasswordVisible = false, isCurrentPasswordVisible = false, isNewPasswordVisible = false, isConfirmPasswordVisible = false;


  late TextEditingController emailController, phoneNumberController, passwordController,
      currentPasswordController, newPasswordController, confirmPasswordController;

  String phoneCountryCode = "+20";

  @override
  void initState() {
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  Future changeEmail() async {
    String? messageValidate = Validate.validateEmail(emailController.text);
    if(messageValidate != null) {
      ToastHelper.showError(message: messageValidate);
      return;
    }
    setState(()=> loading = true);
    final result = await SecurityAndPrivacyDataHandler.changeEmail(email: emailController.text);
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> currentContext_!.pushNamed(
        OtpCodeScreen.routeName,
        extra: {
          "emailOrPhone": emailController.text,
          "onVerify": onVerifyEmailOtp,
        },
      ),
    );
    setState(()=> loading = false);
  }

  Future changePhoneNumber() async {
    String? messageValidate = Validate.validatePhoneNumber(phoneNumberController.text);
    if(messageValidate != null) {
      ToastHelper.showError(message: messageValidate);
      return;
    }
    setState(()=> loading = true);
    final result = await SecurityAndPrivacyDataHandler.changePhone(phone: phoneNumberController.text, countryCode: phoneCountryCode);
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> currentContext_!.pushNamed(
        OtpCodeScreen.routeName,
        extra: {
          "emailOrPhone": phoneNumberController.text,
          "countryCode": phoneCountryCode,
          "onVerify": onVerifyPhoneOtp,
        },
      ),
    );
    setState(()=> loading = false);
  }

  Future onVerifyEmailOtp(String otpCode) async {
    final result = await OtpCodeDataHandler.verifyChangeEmailOrPhone(
      otpCode: otpCode,
    );
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> DialogHelper.custom(context: currentContext_!).customDialog(
        dismiss: false,
        onDismiss: ()=> currentContext_?.pop(),
        dialogWidget: const ChangeEmailSuccessWidget(),
      ),
    );
  }

  Future onVerifyPhoneOtp(String otpCode) async {
    final result = await OtpCodeDataHandler.verifyChangeEmailOrPhone(
      otpCode: otpCode,
    );
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> DialogHelper.custom(context: currentContext_!).customDialog(
        dismiss: false,
        onDismiss: ()=> currentContext_?.pop(),
        dialogWidget: const ChangePhoneNumberSuccessWidget(),
      ),
    );
  }


  Future deleteMyAccount() async {
    String? messageValidate = Validate.validateNormalString(passwordController.text);
    if(messageValidate != null) {
      ToastHelper.showError(message: messageValidate);
      return;
    }
    setState(()=> loading = true);
    final result = await SecurityAndPrivacyDataHandler.deleteMyAccount(password: passwordController.text);
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> DialogHelper.custom(context: currentContext_!).customDialog(
        dismiss: false,
        onDismiss: LogoutController.logOut,
        dialogWidget: const DeleteAccountSuccessWidget(),
      ),
    );
    setState(()=> loading = false);
  }

  Future changePassword() async {
    setState(()=> loading = true);
    final result = await SecurityAndPrivacyDataHandler.changePassword(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      confPassword: confirmPasswordController.text,
    );
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> DialogHelper.custom(context: currentContext_!).customDialog(
        dismiss: false,
        onDismiss: ()=> currentContext_?.pop(),
        dialogWidget: const ChangePasswordSuccessWidget(),
      ),
    );
    setState(()=> loading = false);
  }

}
