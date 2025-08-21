import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Utilities/text_style_helper.dart';
import '../Utilities/theme_helper.dart';

class CustomDropDownWidget<T> extends StatelessWidget {
  final Widget? prefixIcon;
  final Color? borderColor,backgroundColor;
  final double? width;
  final double? height;
  final double borderRadiusValue;
  final bool underLineBorder;
  final List<DropdownMenuItem<T>> items;
  final T? selected;
  final void Function(T?) onChange;
  final String hint;
  final String? Function(dynamic)? validate;
  final TextStyle? style;
final EdgeInsetsGeometry? contentPadding;
  const CustomDropDownWidget(
      {Key? key,
        this.prefixIcon,
        this.selected,
        this.underLineBorder = false,
        required this.onChange,
        required this.hint,
        this.validate,
        this.width,
        this.borderRadiusValue = 12,
        required this.items,
        this.borderColor,
        this.backgroundColor, this.height, this.style, this.contentPadding,
      })
      : super(key: key);

  InputBorder? getBorder({double? radius,Color? color}){
    if(underLineBorder) {
      return UnderlineInputBorder(
        borderSide: BorderSide(
            color: color ?? ThemeClass.of(currentContext_!).primaryColor,
            width: 1.r
        ),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius ?? 16.r),
      borderSide: BorderSide(color: color ?? ThemeClass.of(currentContext_!).lightGreyColor,width: 1.r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: height,
      child: DropdownButtonFormField<T>(
        validator: validate,
        iconSize: 24.r,
        icon: Icon(Icons.keyboard_arrow_down_outlined,color: ThemeClass.of(context).primaryColor,size: 24.r,),
        value: selected,
        style: TextStyleHelper.of(context).s14RegTextStyle,
        dropdownColor: ThemeClass.of(context).cartColor,
        decoration: InputDecoration(
          isDense: false,
          errorStyle: const TextStyle(height: 0),
          contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 16.h, horizontal: 28.w),
          enabled: true,
          enabledBorder: getBorder(radius: borderRadiusValue, color: borderColor),
          disabledBorder: getBorder(radius: borderRadiusValue, color: borderColor),
          focusedBorder: getBorder(radius: borderRadiusValue,),
          border: getBorder(radius: borderRadiusValue),
          errorBorder: getBorder(radius: borderRadiusValue, color: ThemeClass.of(context).warningColor),
          suffixIcon: prefixIcon,
          filled: true,
          fillColor: backgroundColor ?? Colors.transparent,
          hintText: hint,
          hintStyle: TextStyleHelper.of(context).s16RegTextStyle.copyWith(color: ThemeClass.of(context).darkGreyColor),
        ),
        items: items,
        onChanged: onChange,
      ),
    );
  }
}