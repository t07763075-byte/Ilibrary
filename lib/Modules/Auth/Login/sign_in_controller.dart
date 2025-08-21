import 'package:ELibrary/Models/user_model.dart';
import 'package:ELibrary/Modules/Auth/Login/sign_in_data_handler.dart';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Utilities/router_config.dart';
import '../../../Utilities/toast_helper.dart';
import '../../Home/Home/home_screen.dart';

class SignInController extends StateXController {
  // singleton
  static SignInController? _this;
  SignInController._();
  factory SignInController() => _this ??= SignInController._();

  late TextEditingController emailController, phoneNumberController,passwordController;

  bool loading = false, autoValidate = false, isPasswordVisible = false, isRememberMe = false, isSelectEmail = true;

  String phoneCountryCode = "+20";

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


  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    setState(() {});
  }

  void toggleRememberMe(value) {
    isRememberMe = value;
    setState(() {});
  }

  Future login()async{
    setState(() {loading = true;});
    final result = await SignInDataHandler.login(
        emailOrPhone: isSelectEmail? emailController.text : phoneNumberController.text,
        countryCode: phoneCountryCode,
        password: passwordController.text,
    );
    setState(() {loading = false;});
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      _onLogin,
    );
  }

  void _onLogin(UserModel userModel) async{
    await SharedPref.saveCurrentUser(user: userModel);
    ToastHelper.showSuccess(message: "Hello World");
    currentContext_!.goNamed(HomeScreen.routeName,);
  }
}
