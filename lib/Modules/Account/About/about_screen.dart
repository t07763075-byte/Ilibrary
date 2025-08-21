import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';

import 'about_controller.dart';
class AboutScreen extends StatefulWidget {
  static const routeName="About";
  const AboutScreen({super.key});

  @override
   createState() => _AboutScreenState();
}

class _AboutScreenState extends StateX<AboutScreen> {
  _AboutScreenState():super(controller:AboutController() ){
    con=AboutController();

  }
  late AboutController con;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.aboutILibrary.tr,
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 24.h),
          children: [
            SvgPicture.asset(Assets.imagesAboutLogoIc),
            Gap(8.h),
            Center(child: Text("${Strings.iLibrary.tr} v1.0.0",style: TextStyleHelper.of(context).s24SemiBoldTextStyle,)),
            Divider(
              height: 40.h,
              color: ThemeClass.of(context).alertBackground,
              thickness: 1.h,
            ),
            AboutWidget(title: Strings.aboutILibrary.tr),
            Gap(38.h),
            AboutWidget(title: Strings.feedback.tr),
            Gap(38.h),
            AboutWidget(title: Strings.rateUs.tr),
            Gap(38.h),
            AboutWidget(title: Strings.privacyPolicy.tr),
            Gap(38.h),
            AboutWidget(title: Strings.termsOfUse.tr),
          ],
        ),
      ),
    );
  }
}

class AboutWidget extends StatelessWidget {
  final String title;
  const AboutWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Expanded(child: Text(title,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,)),
          Icon(Icons.arrow_forward_ios,color: ThemeClass.of(context).mainTextColor,size: 20.r,)
        ],
      ),
    );
  }
}
