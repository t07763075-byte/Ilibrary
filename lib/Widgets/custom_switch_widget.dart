import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilities/theme_helper.dart';

class CustomSwitchWidget extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const CustomSwitchWidget({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value); // Toggle the switch
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: value ? ThemeClass.of(context).primaryColor :ThemeClass.of(context).alertBackground,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Stack(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            AnimatedPositionedDirectional(
              duration: const Duration(milliseconds: 300),
              start: value ? 20.w : 0,
              end: value ? 0 : 20.w,
              top: 2.h,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300), // Thumb animation duration
                width: 20.r,
                height: 20.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeClass.of(context).mainTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}