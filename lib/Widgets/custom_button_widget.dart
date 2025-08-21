import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilities/text_style_helper.dart';
import '../Utilities/theme_helper.dart';

enum ButtonTypes {
  primary,
  secondary,
  outline,
}

class CustomButtonWidget extends StatelessWidget {
  final Widget? child;
  final String? title;
  final double? width, height;
  final ButtonTypes buttonTypes;
  final Function()? onTap;
  final bool enableAnimated;

  final double? radius;
  final Color? backgroundColor;

  double get _radius => 100.r;

  const CustomButtonWidget.primary(
      {super.key,
      this.radius,
      this.width,
      this.height,
      this.title,
      this.onTap,
      this.child,
      this.enableAnimated = false})
      : buttonTypes = ButtonTypes.primary,
        backgroundColor = null;

  const CustomButtonWidget.secondary(
      {super.key,
      this.radius,
      this.width,
      this.height,
      this.title,
      this.onTap,
      this.child,
      this.enableAnimated = false})
      : buttonTypes = ButtonTypes.secondary,
        backgroundColor = null;

  const CustomButtonWidget.outline(
      {super.key,
      this.radius,
      this.width,
      this.height,
      this.title,
      this.onTap,
      this.child,
      this.enableAnimated = false})
      : buttonTypes = ButtonTypes.outline,
        backgroundColor = null;

  const CustomButtonWidget.custom(
      {super.key,
      this.radius,
      this.width,
      this.height,
      this.title,
      this.onTap,
      this.child,
      required this.buttonTypes,
      this.enableAnimated = false})
      : backgroundColor = null;

  const CustomButtonWidget.customPrimary({
    super.key,
    required this.backgroundColor,
    this.radius,
    this.width,
    this.height,
    this.onTap,
    required Widget this.child,
    this.enableAnimated = false,
  })  : buttonTypes = ButtonTypes.primary,
        title = null;

  BoxDecoration getDecoration(BuildContext context) {
    final primaryDecoration = BoxDecoration(
      color: backgroundColor ?? ThemeClass.of(context).primaryColor,
      borderRadius: BorderRadius.circular(radius ?? _radius),
    );
    final secondaryDecoration = BoxDecoration(
      color: backgroundColor ?? ThemeClass.of(context).alertBackground,
      borderRadius: BorderRadius.circular(radius ?? _radius),
    );
    final outlinedDecoration = BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius ?? _radius),
        border:
            Border.all(color: ThemeClass.of(context).primaryColor, width: 2.r));

    switch (buttonTypes) {
      case ButtonTypes.primary:
        return primaryDecoration;
      case ButtonTypes.secondary:
        return secondaryDecoration;
      case ButtonTypes.outline:
        return outlinedDecoration;
    }
  }

  Color getTitleColor(BuildContext context) {
    switch (buttonTypes) {
      case ButtonTypes.primary:
        return Colors.white;
      case ButtonTypes.secondary:
        return ThemeClass.of(context).mainTextColor;
      case ButtonTypes.outline:
        return ThemeClass.of(context).mainTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedLoadingWidget(
      enableAnimated: enableAnimated,
      width: width,
      height: height,
      radius: radius ?? _radius,
      decoration: getDecoration(context),
      onTap: onTap,
      titleColor: getTitleColor(context),
      child: child ??
          Text(
            title ?? '',
            style: TextStyleHelper.of(context)
                .s16SemiBoldTextStyle
                .copyWith(color: getTitleColor(context)),
          ),
    );
  }
}

class AnimatedLoadingWidget extends StatefulWidget {
  final Widget child;
  final double? width, height;
  final Decoration decoration;
  final Function()? onTap;
  final double radius;
  final Color titleColor;
  final bool enableAnimated;

  const AnimatedLoadingWidget(
      {super.key,
      required this.child,
      required this.width,
      required this.height,
      required this.decoration,
      required this.onTap,
      required this.radius,
      required this.titleColor,
      required this.enableAnimated});

  @override
  State<AnimatedLoadingWidget> createState() => _AnimatedLoadingWidgetState();
}

class _AnimatedLoadingWidgetState extends State<AnimatedLoadingWidget> {
  late double? buttonWidth;
  bool loading = false;

  @override
  void initState() {
    buttonWidth = widget.width ?? 430.w;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.onTap == null) return;
        if (widget.enableAnimated)
          setState(() {
            buttonWidth = widget.height ?? 58.h;
            loading = true;
          });
        await widget.onTap?.call();
        if (widget.enableAnimated)
          setState(() {
            buttonWidth = widget.width ?? 430.w;
            loading = false;
          });
      },
      borderRadius: BorderRadius.circular(widget.radius),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: buttonWidth,
        height: widget.height ?? 58.h,
        alignment: Alignment.center,
        decoration: widget.decoration,
        child: loading
            ? CircularProgressIndicator(
                color: widget.titleColor,
              )
            : widget.child,
      ),
    );
  }
}
