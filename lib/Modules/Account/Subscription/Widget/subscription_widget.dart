import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../Utilities/format_date_helper.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';

class SubscriptionWidget extends StatelessWidget {
  const SubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ThemeClass.of(context).cartColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text("Invoice 0012",style: TextStyleHelper.of(context).s18SemiBoldTextStyle,)),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 23.w, vertical: 4.h),
                decoration: BoxDecoration(
                    color: ThemeClass.of(context).successColor,
                    borderRadius: BorderRadius.circular(16.r)),
                child: Text(
                  "Paid",
                  style: TextStyleHelper.of(context)
                      .s10SemiBoldTextStyle,
                ),
              ),
            ],
          ),
          Gap(4.h),
          Row(
            children: [
              Expanded(child: Text("Annual Plan",style: TextStyleHelper.of(context).s14SemiBoldTextStyle,)),
              Text(
                "\$999/Year",
                style: TextStyleHelper.of(context)
                    .s14SemiBoldTextStyle.copyWith(
                    color: ThemeClass.of(context).primaryColor
                ),
              ),
            ],
          ),
          Gap(4.h),
          Text(FormatDateHelper.formatDateSubscription.format(DateTime.now()),style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
              color: ThemeClass.of(context).darkGreyColor
          ),)
        ],
      ),
    );
  }
}
