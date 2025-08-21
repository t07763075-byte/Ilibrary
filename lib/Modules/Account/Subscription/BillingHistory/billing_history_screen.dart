import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';

import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Widgets/custom_textfield_widget.dart';
import '../../../../generated/assets.dart';
import '../Widget/subscription_widget.dart';
import 'billing_history_controller.dart';

class BillingHistoryScreen extends StatefulWidget {
  static const routeName = "BillingHistory";

  const BillingHistoryScreen({super.key});

  @override
  createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends StateX<BillingHistoryScreen> {
  _BillingHistoryScreenState() : super(controller: BillingHistoryController()) {
    con = BillingHistoryController();
  }

  late BillingHistoryController con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.billingHistory.tr,
      ),
      body: Column(
        children: [
          CustomTextFieldWidget(
            width: 382.w,
            hint: Strings.search.tr,
            backGroundColor: ThemeClass.of(context).cartColor,
            borderColor: ThemeClass.of(context).cartColor,
            insidePadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
            style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
            isDense: true,
            prefixIcon: Padding(
              padding:  EdgeInsetsDirectional.only(start: 12.w,end: 12.w),
              child: SvgPicture.asset(Assets.imagesSearchIc,height: 20.r,),
            ),
            onchange: con.onSearch,
          ),
          Gap(16.h),
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
    );
  }
}
