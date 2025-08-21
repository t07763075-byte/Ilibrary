import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/router_config.dart';
import '../../../Utilities/toast_helper.dart';
import '../CreateNewPassword/create_new_password_screen.dart';
import '../OtpCode/otp_code_data_handler.dart';
import '../OtpCode/otp_code_screen.dart';

class ForgotPasswordController extends StateXController {
  // singleton
  static ForgotPasswordController? _this;
  ForgotPasswordController._();
  factory ForgotPasswordController() => _this ??= ForgotPasswordController._();

  late TextEditingController emailController, phoneNumberController,passwordController;
  bool loading = false;

  @override
  initState() {
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isSelectEmail = true;
  String phoneCountryCode = "+20";

  Future onSendOtp() async {
    setState(()=> loading = true);
    final result = await OtpCodeDataHandler.resendOtp(
      emailOrPhone: isSelectEmail ? emailController.text : phoneNumberController.text,
      countryCode: phoneCountryCode,
    );
    setState(()=> loading = false);
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r){
        currentContext_!.pushNamed(
          OtpCodeScreen.routeName,
          extra: {
            "emailOrPhone": isSelectEmail? emailController.text : phoneNumberController.text,
            "countryCode": phoneCountryCode,
            "onVerify": onVerifyOtp,
          },
        );
      }
    );
  }


  Future onVerifyOtp(String otpCode) async {
    final result = await OtpCodeDataHandler.verifyOtp(
      otpCode: otpCode,
      emailOrPhone: isSelectEmail ? emailController.text : phoneNumberController.text,
      countryCode: phoneCountryCode,
    );
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> currentContext_!.pushNamed(
        CreateNewPasswordScreen.routeName,
        queryParameters: {
          "emailOrPhone": isSelectEmail ? emailController.text : phoneNumberController.text,
          "countryCode": phoneCountryCode
        },
      ),
    );
  }
}
