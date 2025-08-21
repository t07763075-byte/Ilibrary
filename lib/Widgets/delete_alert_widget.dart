import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../Utilities/strings.dart';
import '../Utilities/text_style_helper.dart';
import '../Utilities/theme_helper.dart';
import 'custom_button_widget.dart';

class DeleteAlertWidget extends StatelessWidget {
  final Function() onDelete;
  final String message;
  const DeleteAlertWidget({super.key, required this.onDelete, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(8.h),
          Center(
            child: Container(
              height: 3.h,
              width: 38.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: ThemeClass.of(context).alertBackground),
            ),
          ),
          Gap(24.h),
          Text(
            message,
            style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
              height: 1.5
            ),
            textAlign: TextAlign.center,
          ),
          Gap(24.h),
          Row(
            children: [
              Expanded(
                child: CustomButtonWidget.secondary(
                  title: Strings.cancel.tr,
                  onTap: context.pop,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: CustomButtonWidget.customPrimary(
                  onTap:()async{
                    await onDelete();
                    if(context.mounted) context.pop();
                    },
                  backgroundColor: ThemeClass.of(context).warningColor,
                  child: Text(Strings.delete.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                ),
              ),
            ],
          ),
          Gap(38.h),
        ],
      ),
    );
  }
}
