import 'package:ELibrary/Modules/Auth/Register/sign_up_data_handler.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/shared_preferences.dart';
import '../ChooseBookGenre/choose_book_genre_screen.dart';
import '../OtpCode/otp_code_data_handler.dart';
import '../OtpCode/otp_code_screen.dart';

class SignUpController extends StateXController {
  // singleton
  static SignUpController? _this;
  SignUpController._();
  factory SignUpController() => _this ??= SignUpController._();

  late TextEditingController phoneNumberController,emailController,passwordController,confirmPasswordController;

  bool loading = false, autoValidate = false, isPasswordVisible = false, isConfirmPasswordVisible = false, agreeTermsAndConditions = false, isSelectEmail = true;


  String phoneCountryCode = "+20";


  @override
  void initState() {
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    setState(() {});
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    setState(() {});
  }

  void toggleTermsAndConditions(value) {
    agreeTermsAndConditions = value;
    setState(() {});
  }

  Future register()async{
    setState(()=> loading = true);
    final result = await SignUpDataHandler.register(
        email: emailController.text,
        phone: phoneNumberController.text,
        countryCode: phoneCountryCode,
        password: passwordController.text,
        confPassword: confirmPasswordController.text,
    );
    setState(()=> loading = false);
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r){
        currentContext_!.pushNamed(
          OtpCodeScreen.routeName,
          extra: {
            "emailOrPhone": isSelectEmail? emailController.text : phoneNumberController.text,
            "countryCode": phoneCountryCode,
            "onVerify": onVerifyOtp,
          },
        );
      },
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
      (r) async{
        await SharedPref.saveCurrentUser(user: r);
        currentContext_!.pushNamed(ChooseBookGenreScreen.routeName);
      },
    );
  }
}
