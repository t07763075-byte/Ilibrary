import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../Utilities/strings.dart';

class CustomPasswordValidationWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final bool isFirstTimeValidate;
  const CustomPasswordValidationWidget({super.key, required this.passwordController, required this.isFirstTimeValidate});

  @override
  State<CustomPasswordValidationWidget> createState() => _CustomPasswordValidationWidgetState();
}

class _CustomPasswordValidationWidgetState extends State<CustomPasswordValidationWidget> {
  bool isValidPassword = false, isAtLeast8Digit = false, isAtLeast1Lowercase = false, isAtLeast1Uppercase = false, showValidateWidget = false;

  @override
  void initState() {
    widget.passwordController.addListener(onPasswordChangedListener);
    onPasswordChangedListener();
    super.initState();
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(onPasswordChangedListener);
    super.dispose();
  }

  void onPasswordChangedListener() {
    isAtLeast1Lowercase = widget.passwordController.text.contains(RegExp(r'[a-z]'));
    isAtLeast1Uppercase = widget.passwordController.text.contains(RegExp(r'[A-Z]'));
    isAtLeast8Digit = widget.passwordController.text.length >= 8;
    if(widget.passwordController.text.isNotEmpty) showValidateWidget = true;
    isValidPassword = isAtLeast1Lowercase && isAtLeast1Uppercase && isAtLeast8Digit;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    TextStyle errorStyle = TextStyleHelper.of(context).s12RegTextStyle.copyWith(color: ThemeClass.of(context).warningColor,height: 1.4);
    TextStyle successStyle = TextStyleHelper.of(context).s12RegTextStyle.copyWith(color: ThemeClass.of(context).successColor,height: 1.4);

    if(!showValidateWidget) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isValidPassword ? ThemeClass.of(context).successColor.withOpacity(0.08) : ThemeClass.of(context).warningColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6.r),
      ),
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 6.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(!isValidPassword) Text(widget.isFirstTimeValidate? Strings.passwordMustHave.tr:Strings.weakPasswordMessage.tr,style: errorStyle,),
          if(!isValidPassword) Gap(4.h),

          Text("●  ${Strings.passwordRuleMinLength.tr}",style: isAtLeast8Digit? successStyle : errorStyle,),
          Text("●  ${Strings.passwordRuleUppercase.tr}",style: isAtLeast1Uppercase? successStyle : errorStyle,),
          Text("●  ${Strings.passwordRuleLowercase.tr}",style: isAtLeast1Lowercase? successStyle : errorStyle,),
        ],
      ),
    );
  }


}
