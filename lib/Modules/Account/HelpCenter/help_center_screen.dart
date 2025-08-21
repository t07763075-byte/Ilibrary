import 'package:ELibrary/Modules/Account/HelpCenter/screens/contact_support_screen.dart';
import 'package:ELibrary/Modules/Account/HelpCenter/screens/faqs_screen.dart';
import 'package:ELibrary/Modules/Account/HelpCenter/screens/privacy_policy_screen.dart';
import 'package:ELibrary/Modules/Account/HelpCenter/screens/terms_conditions_screen.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/text_style_helper.dart';
import '../../../Utilities/theme_helper.dart';
import 'help_center_controller.dart';

class HelpCenterScreen extends StatefulWidget {
  static const routeName = "HelpCenter";

  const HelpCenterScreen({super.key});

  @override
  createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends StateX<HelpCenterScreen> {
  _HelpCenterScreenState() : super(controller: HelpCenterController()) {
    con = HelpCenterController();
  }

  late HelpCenterController con;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(screenName: Strings.helpCenter.tr,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 32.h),
        child: Column(
          children: [
            HelpCenterWidget(
              title: Strings.faq.tr,
              onTap: ()=> context.pushNamed(FAQsScreen.routeName),
            ),
            HelpCenterWidget(
              title: Strings.contactSupport.tr,
              onTap: ()=> context.pushNamed(ContactSupportScreen.routeName),
            ),
            HelpCenterWidget(
              title: Strings.privacyPolicy.tr,
              onTap: ()=> context.pushNamed(PrivacyPolicyScreen.routeName),
            ),
            HelpCenterWidget(
              title: Strings.termsAndConditions.tr,
              onTap: ()=> context.pushNamed(TermsConditionsScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpCenterWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  const HelpCenterWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Expanded(child: Text(title,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,)),
            Icon(Icons.arrow_forward_ios,color: ThemeClass.of(context).mainTextColor,size: 20.r,)
          ],
        ),
      ),
    );
  }
}

