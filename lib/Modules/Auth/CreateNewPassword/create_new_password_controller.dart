import 'package:ELibrary/Modules/Auth/Login/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/dialog_helper.dart';
import '../../../Utilities/router_config.dart';
import '../../../Utilities/toast_helper.dart';
import '../Widget/reset_password_success_widget.dart';
import 'create_password_data_handler.dart';


class CreateNewPasswordController extends StateXController {
  // singleton
  static CreateNewPasswordController? _this;
  CreateNewPasswordController._();
  factory CreateNewPasswordController() => _this ??= CreateNewPasswordController._();

  late TextEditingController passwordController, confirmPasswordController;

  bool loading = false, autoValidate = false, passwordVisible = false, confirmPasswordVisible = false;
  @override
  initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future confirm({required String emailOrPhone,required String? countryCode})async{
    setState(()=> loading = true);
    final result = await CreatePasswordDataHandler.createPassword(
      emailOrPhone: emailOrPhone,
      countryCode: countryCode,
      password: passwordController.text,
      confPassword: confirmPasswordController.text,
    );
    setState(()=> loading = false);

    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> DialogHelper.custom(context: currentContext_!).customDialog(
        dismiss: false,
        onDismiss: ()=> currentContext_!.pushNamed(SignInScreen.routeName),
        dialogWidget: const ResetPasswordSuccessWidget(),
      ),
    );

  }
}
