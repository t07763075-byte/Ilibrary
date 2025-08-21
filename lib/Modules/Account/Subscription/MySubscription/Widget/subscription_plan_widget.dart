import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../Utilities/theme_helper.dart';
import '../my_subscription_controller.dart';
class SubscriptionPlanWidget extends StatefulWidget {
  const SubscriptionPlanWidget({super.key});

  @override
   createState() => _SubscriptionPlanWidgetState();
}

class _SubscriptionPlanWidgetState extends State<SubscriptionPlanWidget> {
  bool annual=true;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(8.h),
          Center(
            child: Container(height: 3.h,
              width:38.w ,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: ThemeClass.of(context).alertBackground
              ),),
          ),
          Gap(24.h),
          Text(Strings.chooseSubscriptionPlan.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
          Gap(24.h),
          Text(Strings.chooseSubscriptionPlanDes.tr,style: TextStyleHelper.of(context).s14RegTextStyle,),
          Gap(24.h),
          InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: ()=>setState(() {
              annual=true;
            }),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: ThemeClass.of(context).backGroundColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(width: 1.r,color:annual? ThemeClass.of(context).primaryColor:Colors.transparent)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Annual",style: TextStyleHelper.of(context).s14SemiBoldTextStyle,),
                      const Spacer(),
                     if(annual) Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 9.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            color: ThemeClass.of(context).warningColor,
                            borderRadius: BorderRadius.circular(16.r)),
                        child: Text(
                          "Best Value",
                          style: TextStyleHelper.of(context).s10SemiBoldTextStyle
                        ),
                      ),
                    ],
                  ),
                  Gap(4.h),
                  Text("First 30 days free - Then \$999/Year",style: TextStyleHelper.of(context).s12RegTextStyle,),
                  Gap(8.h),
                  InkWell(
                    onTap: MySubscriptionController().subscriptionDetails,
                    child: Text(Strings.viewDetails.tr,style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                      color: ThemeClass.of(context).primaryColor
                    ),),
                  ),

                ],
              ),
            ),
          ),
          Gap(16.h),
          InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: ()=>setState(() {
              annual=false;
            }),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: ThemeClass.of(context).backGroundColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(width: 1.r,color:!annual? ThemeClass.of(context).primaryColor:Colors.transparent)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Monthly",style: TextStyleHelper.of(context).s14SemiBoldTextStyle,),
                      const Spacer(),
                      if(!annual)  Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 9.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            color: ThemeClass.of(context).warningColor,
                            borderRadius: BorderRadius.circular(16.r)),
                        child: Text(
                          "Best Value",
                          style: TextStyleHelper.of(context)
                              .s10SemiBoldTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Gap(4.h),
                  Text("First 30 days free - Then \$999/Year",style: TextStyleHelper.of(context).s12RegTextStyle,),
                  Gap(8.h),
                  InkWell(
                    onTap: MySubscriptionController().subscriptionDetails,
                    child: Text(Strings.viewDetails.tr,style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                      color: ThemeClass.of(context).primaryColor
                    ),),
                  ),

                ],
              ),
            ),
          ),
          Gap(16.h),
          Gap(24.h),
          const CustomButtonWidget.primary(
            title: "Start 30-day free trial",
          ),
          Gap(36.h),
        ],
      ),
    );
  }
}
