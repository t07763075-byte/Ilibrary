import 'package:ELibrary/Modules/Account/SecurityAndPrivacy/Screens/change_password_screen.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/bottom_sheet_helper.dart';
import '../../../Widgets/delete_account_alert_widget.dart';
import 'Screens/change_email_screen.dart';
import 'Screens/change_phone_number_screen.dart';
import 'security_and_privacy_controller.dart';

class SecurityAndPrivacyScreen extends StatefulWidget {
  static const routeName="securityAndPrivacy";
  const SecurityAndPrivacyScreen({super.key});

  @override
   createState() => _SecurityAndPrivacyScreenState();
}

class _SecurityAndPrivacyScreenState extends StateX<SecurityAndPrivacyScreen> {
  _SecurityAndPrivacyScreenState():super(controller:SecurityAndPrivacyController() ){
    con=SecurityAndPrivacyController();

  }
  late SecurityAndPrivacyController con;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.securityAndPrivacy.tr,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
        child: Column(
          children: [
            Gap(32.h),
            SecurityAndPrivacyWidget(
              title: Strings.changeEmail.tr,
              onTap: ()=> context.pushNamed(ChangeEmailScreen.routeName),
            ),
            SecurityAndPrivacyWidget(
              title: Strings.changePhoneNumber.tr,
              onTap: ()=> context.pushNamed(ChangePhoneNumberScreen.routeName),
            ),
            SecurityAndPrivacyWidget(
              title: Strings.changePassword.tr,
              onTap: ()=> context.pushNamed(ChangePasswordScreen.routeName),
            ),
            // SecurityAndPrivacyWidget(
            //   title: Strings.notification.tr,
            //   onTap: (){},
            // ),
            SecurityAndPrivacyWidget(
              title: Strings.deleteMyAccount.tr,
              onTap: (){
                BottomSheetHelper.bottomSheet(
                  context: context,
                  widget: const DeleteAccountAlertWidget(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityAndPrivacyWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  const SecurityAndPrivacyWidget({super.key, required this.title, required this.onTap});

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
