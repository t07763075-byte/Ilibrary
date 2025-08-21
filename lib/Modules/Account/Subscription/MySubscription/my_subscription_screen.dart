import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../BillingHistory/billing_history_screen.dart';
import 'Widget/empty_subscription_widget.dart';
import '../Widget/subscription_widget.dart';
import 'my_subscription_controller.dart';

class MySubscriptionScreen extends StatefulWidget {
  static const routeName = "MySubscription";

  const MySubscriptionScreen({super.key});

  @override
  createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends StateX<MySubscriptionScreen> {
  _MySubscriptionScreenState() : super(controller: MySubscriptionController()) {
    con = MySubscriptionController();
  }

  late MySubscriptionController con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.mySubscription.tr,
      ),
      body: Visibility(
        visible: false,
        replacement: const EmptySubscriptionWidget(),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SvgPicture.asset(Assets.imagesMySubscriptionCardIc),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Annual",
                            style:
                                TextStyleHelper.of(context).s14SemiBoldTextStyle,
                          )),
                          Container(
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
                      Text(
                        "First 30 days free - Then 999/Year",
                        style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(24.h),
            InkWell(
              onTap: ()=>context.pushNamed(BillingHistoryScreen.routeName),
              child: Row(
                children: [
                  Gap(24.w),
                  Expanded(
                      child: Text(
                    Strings.billingHistory.tr,
                    style: TextStyleHelper.of(context).s24SemiBoldTextStyle,
                  )),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: ThemeClass.of(context).primaryColor,
                  ),
                  Gap(24.w),
                ],
              ),
            ),
            Gap(8.h),
            Expanded(
                child: ListView.separated(
                  padding:EdgeInsetsDirectional.only(start: 24.w, top: 12.h,end: 24.w,bottom: 28.h) ,
                    itemBuilder: (_, index)=> GestureDetector(
                      onTap: con.subscriptionDetails,
                        child: const SubscriptionWidget()),
                    separatorBuilder: (_, __) => Gap(12.h),
                    itemCount: 10))
          ],
        ),
      ),
    );
  }
}
