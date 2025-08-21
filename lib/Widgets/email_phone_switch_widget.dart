import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailPhoneSwitchWidget extends StatefulWidget {
  final bool initSelectEmail;
  final Function(bool) onChange;
  const EmailPhoneSwitchWidget({super.key, this.initSelectEmail = true, required this.onChange});

  @override
  State<EmailPhoneSwitchWidget> createState() => _EmailPhoneSwitchWidgetState();
}

class _EmailPhoneSwitchWidgetState extends State<EmailPhoneSwitchWidget> {
  late bool isSelectEmail;
  @override

  void initState() {
    isSelectEmail = widget.initSelectEmail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButtonWidget.custom(
          buttonTypes: isSelectEmail ? ButtonTypes.primary : ButtonTypes.outline,
          width: 180.w,
          height: 45.h,
          radius: 100.r,
          onTap: (){
            setState(() {isSelectEmail = true;});
            widget.onChange(true);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(Assets.imagesEmail,width: 18.r,height: 18.r,
              colorFilter: ColorFilter.mode(isSelectEmail ? ThemeClass.of(context).mainTextColor : ThemeClass.of(context).primaryColor, BlendMode.srcIn),),
              Text(Strings.emailAddress.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
                  color: isSelectEmail ? ThemeClass.of(context).mainTextColor : ThemeClass.of(context).primaryColor
              ),),
            ],
          ),
        ),
        CustomButtonWidget.custom(
          buttonTypes: !isSelectEmail ? ButtonTypes.primary : ButtonTypes.outline,
          width: 180.w,
          height: 45.h,
          radius: 100.r,
          onTap: (){
            setState(() {isSelectEmail = false;});
            widget.onChange(false);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(Assets.imagesPhone,width: 20.r,height: 20.r,
                colorFilter: ColorFilter.mode(!isSelectEmail ? ThemeClass.of(context).mainTextColor : ThemeClass.of(context).primaryColor, BlendMode.srcIn),),
              Text(Strings.phoneNumber.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
                color: !isSelectEmail ? ThemeClass.of(context).mainTextColor : ThemeClass.of(context).primaryColor
              ),),
            ],
          ),
        ),
      ],
    );
  }
}
