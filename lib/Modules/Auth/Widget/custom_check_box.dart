import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        height: 24.h,
        width: 24.h,
        decoration: BoxDecoration(
          color:
              value ? ThemeClass.of(context).primaryColor : Colors.transparent,
          border: Border.all(
            color: ThemeClass.of(context).primaryColor,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: value
            ? const Icon(
                Icons.check,
                size: 16.0,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
