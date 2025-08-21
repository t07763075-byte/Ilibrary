import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:state_extended/state_extended.dart';
import 'otp_code_controller.dart';

class OtpCodeScreen extends StatefulWidget {
  static const String routeName = 'OtpCodeScreen';
  final Function(String)? onVerify;
  final String emailOrPhone;
  final String? countryCode;

  const OtpCodeScreen({Key? key, required this.onVerify, required this.emailOrPhone, this.countryCode}) : super(key: key);


  @override
  createState() => _OtpCodeScreenState();
}

class _OtpCodeScreenState extends StateX<OtpCodeScreen> {
  _OtpCodeScreenState() : super(controller: OtpCodeController()) {
    con = OtpCodeController();
  }

  late OtpCodeController con;
  bool get isSendToEmail => widget.emailOrPhone.contains("@");

  @override
  void initState() {
    con.loading = false;
    con.emailOrPhone = widget.emailOrPhone;
    con.countryCode = widget.countryCode;
    if (widget.onVerify != null) con.onVerify = widget.onVerify!;
    con.restartTimer(init: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget.detailsScreen(),
      resizeToAvoidBottomInset: true,
      body: LoadingScreen(
        loading: con.loading,
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  Strings.gettingOtp.tr,
                  style: TextStyleHelper.of(context).s32SemiBoldTextStyle,
                ),
              ),
              Gap(12.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "${Strings.sentOtpMessage.tr} ${isSendToEmail? Strings.email.tr : Strings.phoneNumber.tr} ${widget.emailOrPhone}",
                  style: TextStyleHelper.of(context).s18RegTextStyle,
                ),
              ),
              Gap(60.h),
              Pinput(
                controller: con.otpCodeController,
                autofocus: true,
                onCompleted: (otp){},
                onSubmitted: (otp){},
                keyboardType: TextInputType.text,
                defaultPinTheme: PinTheme(
                  width: 83.5.w,
                  height: 70.h,
                  textStyle: TextStyleHelper.of(context).s24SemiBoldTextStyle,
                  decoration: BoxDecoration(
                    color: ThemeClass.of(context).cartColor,
                    border: Border.all(color: ThemeClass.of(context).alertBackground),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 83.5.w,
                  height: 70.h,
                  textStyle: TextStyleHelper.of(context).s24SemiBoldTextStyle,
                  decoration: BoxDecoration(
                    color: ThemeClass.of(context).primaryColor.withAlpha(20),
                    border: Border.all(color: ThemeClass.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
              Gap(40.h),


              RichText(
                text: TextSpan(
                  text: Strings.notReceiveCode.tr,
                  style: TextStyleHelper.of(context).s18SemiBoldTextStyle,
                  children: [
                    TextSpan(
                      text: " ${Strings.resend.tr}",
                      style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
                        color: con.resendAfterSeconds > 0? ThemeClass.of(context).lightGreyColor: ThemeClass.of(context).primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if(con.resendAfterSeconds == 0) con.restartTimer();
                        },
                    ),
                  ],
                ),
              ),
              Gap(16.h),
              RichText(
                text: TextSpan(
                  text: Strings.resendCodeAfter.tr,
                  style:
                  TextStyleHelper.of(context).s18SemiBoldTextStyle,
                  children: [
                    TextSpan(
                      text: con.resendAfterSeconds.toString(),
                      style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor,),
                    ),
                    TextSpan(
                      text: ' s',
                      style: TextStyleHelper.of(context).s18SemiBoldTextStyle,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButtonWidget.primary(
                title: Strings.confirm.tr,
                onTap: con.verify,
              )
            ],
          ),
        ),
      ),
    );
  }
}
