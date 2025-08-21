import 'dart:async';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Utilities/toast_helper.dart';
import 'otp_code_data_handler.dart';


class OtpCodeController extends StateXController {
  // singleton
  static OtpCodeController? _this;
  OtpCodeController._();
  factory OtpCodeController() => _this ??= OtpCodeController._();

  static const int secondToResend = 60;

  bool loading = false;
  late Timer? timer;
  int  resendAfterSeconds = secondToResend;
  late TextEditingController otpCodeController;
  Function(String) onVerify = (_){};
  late String emailOrPhone;
  late String? countryCode;

  @override
  void initState() {
    otpCodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    otpCodeController.dispose();
    timer?.cancel();
    super.dispose();
  }
  _startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1), (Timer timer) {
      if (resendAfterSeconds == 0) timer.cancel();
      if (resendAfterSeconds != 0) resendAfterSeconds--;
      setState(() { });
    },
    );
  }

  Future restartTimer({bool init = false}) async{
    bool canStartTimer = true;
    if(!init) canStartTimer = await _resendOtp();
    if(canStartTimer) _startTimer();
    if(canStartTimer) resendAfterSeconds = secondToResend;
    setState(() { });
  }

  Future verify()async{
    setState(() {loading = true;});
    onVerify(otpCodeController.text);
    setState(() {loading = false;});
  }

  Future<bool> _resendOtp()async{
    setState(() {loading = true;});
    final result = await OtpCodeDataHandler.resendOtp(
      emailOrPhone: emailOrPhone,
      countryCode: countryCode ?? ""
    );
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) => null,
    );
    setState(() {loading = false;});
    return result.isRight();
  }
}
