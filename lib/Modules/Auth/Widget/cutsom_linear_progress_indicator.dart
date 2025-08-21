import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator({
    required this.value,
    super.key,
  });
  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.h,
      width: 216.w,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: ThemeClass.of(context).alertBackground,
        valueColor: AlwaysStoppedAnimation<Color>(
          ThemeClass.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(100.r),
      ),
    );
  }
}
