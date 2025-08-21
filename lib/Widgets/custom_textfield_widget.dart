import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utilities/theme_helper.dart';
import '../Utilities/text_style_helper.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final TextAlign textAlign;
  final bool? obscure;
  final bool autofocus;
  final bool? readOnly;
  final String? hint;
  final Color? backGroundColor,focusedBorderColor;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final int? maxLine,minLines;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final bool? enable, isDense;
  final Color? borderColor;
  final bool underLineBorder;
  final FocusNode? focusNode;
  final double? borderRadiusValue, width, cursorHeight;
  final EdgeInsets? insidePadding;
  final void Function(String?)? onSave;
  final Widget? prefixIcon, suffixIcon;
  final void Function(String)? onchange;
  final Function()? onSuffixTap;
  final void Function()? onTap;
  final List<TextInputFormatter>? formatter;
  final TextInputAction? textInputAction;
  final bool? expands;
  const CustomTextFieldWidget({
    Key? key,
    this.initialValue,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.isDense,
    this.style,
    this.onchange,
    this.insidePadding,
    this.validator,
    this.maxLine,
    this.hint,
    this.backGroundColor,
    this.controller,
    this.obscure = false,
    this.enable = true,
    this.readOnly = false,
    this.textInputType = TextInputType.text,
    this.borderColor,
    this.borderRadiusValue,
    this.prefixIcon,
    this.width,
    this.hintStyle,
    this.suffixIcon,
    this.onSuffixTap,
    this.cursorHeight,
    this.onTap,
    this.formatter, this.focusNode, this.focusedBorderColor, this.onSave, this.minLines,
    this.underLineBorder = false, this.textInputAction,
    this.expands,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    InputBorder? getBorder({double? radius,Color? color}){
      if(underLineBorder) {
        return UnderlineInputBorder(
        borderSide: BorderSide(
            color: color ?? ThemeClass.of(context).primaryColor,
            width: 1.r
        ),
      );
      }
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius ?? 16.r),
        borderSide: BorderSide(color: color ?? ThemeClass.of(context).lightGreyColor,width: 1.r),
      );
    }

    return SizedBox(
      width: width,
      // height: height??56.h,
      child: TextFormField(
        initialValue: initialValue,
        autofocus: autofocus,
        textAlign: textAlign,
        textInputAction: textInputAction,
        onFieldSubmitted: onSave,
        focusNode:focusNode ,
        readOnly: readOnly ?? false,
        textAlignVertical: TextAlignVertical.center,
        validator: validator,
        onTap:  onTap,
        enabled: enable,
        inputFormatters: formatter ?? [],
        obscureText: obscure ?? false,
        controller: controller,
        expands: expands??false,
        decoration: InputDecoration(
      errorStyle: const TextStyle(height: 0),
      enabledBorder: getBorder(radius: borderRadiusValue, color: borderColor),
      disabledBorder: getBorder(radius: borderRadiusValue, color: borderColor),
      focusedBorder: getBorder(
          radius: borderRadiusValue,
          color: focusedBorderColor ?? ThemeClass.of(context).primaryColor),
      border: getBorder(radius: borderRadiusValue, color: focusedBorderColor),
      isDense: isDense ?? false,
      prefixIconConstraints: prefixIcon == null
          ? null
          : const BoxConstraints(),
      suffixIconConstraints: suffixIcon == null
          ? null
          : const BoxConstraints(),
      fillColor: backGroundColor,
      filled: backGroundColor != null,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon == null
          ? null
          : InkWell(
        onTap: onSuffixTap,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: suffixIcon,
      ),
      contentPadding: insidePadding ??
          EdgeInsets.symmetric(vertical: 16.h, horizontal: 28.w),
      hintStyle: hintStyle ??
          TextStyleHelper.of(context)
              .s16RegTextStyle
              .copyWith(color: ThemeClass.of(context).darkGreyColor),
    ),
        onChanged: onchange,

        textCapitalization: TextCapitalization.words,
        maxLines: maxLine ?? 1,
        minLines:minLines?? 1 ,
        cursorHeight: cursorHeight,
        keyboardType: textInputType,
        style: style ?? TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).darkGreyColor),
      ),
    );
  }
}
