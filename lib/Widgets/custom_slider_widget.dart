import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilities/theme_helper.dart';
class CustomSliderWidget extends StatelessWidget {
  final Function(double value)onChanged;
  final CustomSliderThumbCircle customSliderThumbCircle;
  final double value;
  final double min,max;
  const CustomSliderWidget({super.key, required this.onChanged, required this.value, required this.min, required this.max, required this.customSliderThumbCircle});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 24.h,
        overlayShape: SliderComponentShape.noOverlay,
        rangeThumbShape: RoundRangeSliderThumbShape(
            pressedElevation: 100,
            disabledThumbRadius: 200,
            elevation: 20,
            enabledThumbRadius: 20.r
        ),

        valueIndicatorShape: SliderComponentShape.noOverlay,
        showValueIndicator: ShowValueIndicator.onlyForContinuous,
        tickMarkShape:SliderTickMarkShape.noTickMark ,

        thumbShape: customSliderThumbCircle,
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        inactiveColor: ThemeClass.of(context).alertBackground,
        activeColor: ThemeClass.of(context).primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}
class CustomSliderThumbCircle extends SliderComponentShape {
  final IconData? icon;
  final String? text;

  CustomSliderThumbCircle({
    this.icon,
    this.text,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(0); // Adjust the thumb radius here
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Draw the thumb circle
    final paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 13.r, paint); // Adjust radius here

    // Draw the icon
    if (icon != null) {
      // Draw the icon
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon!.codePoint),
          style: TextStyle(
            fontSize: 20.r, // Adjust icon size
            fontFamily: icon!.fontFamily,
            package: icon!.fontPackage,
            color: Colors.white,
          ),
        ),
        textDirection: textDirection,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        center - Offset(textPainter.width / 1.8, textPainter.height / 2),
      );
    } else if (text != null) {
      // Draw the text
      final TextPainter textPainter = TextPainter(

        text: TextSpan(
          text: text,
          style: TextStyleHelper.of(currentContext_!).s14SemiBoldTextStyle,
        ),
        textDirection: textDirection,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        center - Offset(textPainter.width / 1.2, textPainter.height / 2),
      );
    }
  }
}