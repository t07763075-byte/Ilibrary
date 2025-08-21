import 'package:ELibrary/Modules/Account/GeneralSettings/general_settings_screen.dart';
import 'package:ELibrary/Modules/Account/Profile/profile_controller.dart';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/custom_network_image.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Widgets/bottom_navbar_widget.dart';
import '../../../core/Language/app_languages.dart';
import '../About/about_screen.dart';
import '../EditProfile/edit_profile_screen.dart';
import '../HelpCenter/help_center_screen.dart';
import '../NotificationSetting/notification_setting_screen.dart';
import '../../../Widgets/custom_switch_widget.dart';
import '../SecurityAndPrivacy/security_and_privacy_screen.dart';
import '../Subscription/MySubscription/my_subscription_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "Profile";

  const ProfileScreen({super.key});

  @override
  createState() => _ProfileScreenState();
}

class _ProfileScreenState extends StateX<ProfileScreen> {
  _ProfileScreenState() : super(controller: ProfileController()) {
    con = ProfileController();
  }

  late ProfileController con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.account.tr,
        showArrowBack: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            Row(
              children: [
                CustomNetworkImage(
                  url: SharedPref.getCurrentUser()?.photoUrl,
                  width: 56.r,
                  height: 56.r,
                  radius: 1000.r,
                ),
                Gap(20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${SharedPref.getCurrentUser()?.firstName ?? ""} ${SharedPref.getCurrentUser()?.lastName ?? ""}",
                        style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                      ),
                      Gap(6.h),
                      Text(
                        SharedPref.getCurrentUser()?.email ?? SharedPref.getCurrentUser()?.phoneNumber ?? "",
                        style: TextStyleHelper.of(context).s14RegTextStyle,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: ()=>context.pushNamed(EditProfileScreen.routeName),
                    child: SvgPicture.asset(Assets.imagesEditProfileIc))
              ],
            ),
            // Divider(
            //   height: 48.h,
            //   thickness: 1.h,
            //   color: ThemeClass.of(context).alertBackground,
            // ),
            // ProfileItemWidget(
            //   title: Strings.mySubscription.tr,
            //   icon: Assets.imagesSubscriptionIc,
            //   onTap: ()=>context.pushNamed(MySubscriptionScreen.routeName),
            //   color: const Color.fromRGBO(27, 172, 75, 0.08),
            // ),
            Divider(
              height: 48.h,
              thickness: 1.h,
              color: ThemeClass.of(context).alertBackground,
            ),
            ProfileItemWidget(
              onTap: ()=>context.pushNamed(NotificationSettingScreen.routeName),
              title: Strings.notification.tr,
              icon: Assets.imagesProfileNotificationIc,
              color: const Color.fromRGBO(255, 90, 95, 0.08),
            ),
            Gap(24.h),
            ProfileItemWidget(
              onTap: ()=>context.pushNamed(SecurityAndPrivacyScreen.routeName),
              title: Strings.securityAndPrivacy.tr,
              icon: Assets.imagesSecurityAndPrivacy,
              color: const Color.fromRGBO(27, 172, 75, 0.08),
            ),
            Gap(24.h),
            // ProfileItemWidget(
            //   onTap: con.onChangeLanguage,
            //   title:AppLocalizations.of(context)?.translate(Strings.language)??'' ,
            //   icon: Assets.imagesLanguageIc,
            //   color: const Color.fromRGBO(248, 147, 0, 0.08),
            //   widget: Row(
            //     children: [
            //       Text(
            //         appLangIsArabic()?Strings.arabic.tr:Strings.english.tr,
            //         style: TextStyleHelper.of(context).s18SemiBoldTextStyle,
            //       ),
            //       Gap(20.w),
            //       Icon(
            //         Icons.arrow_forward_ios,
            //         color: ThemeClass.of(context).mainTextColor,
            //         size: 20.r,
            //       )
            //     ],
            //   ),
            // ),
            // Gap(24.h),
            ProfileItemWidget(
              onTap: ()=>context.pushNamed(GeneralSettingsScreen.routeName),
              title: Strings.generalSettings.tr,
              icon: Assets.imagesAboutIc,
              color: const Color.fromRGBO(248, 147, 0, 0.08),
            ),
            // ProfileItemWidget(
            //   title: Strings.darkMode.tr,
            //   icon: Assets.imagesDarkModeIc,
            //   color: const Color.fromRGBO(36, 107, 253, 0.08),
            //   widget: CustomSwitchWidget(
            //     value: con.isDarkMode,
            //     onChanged: (bool value) {
            //       setState(() {
            //         con.isDarkMode = value;
            //       });
            //     },
            //   ),
            // ),
            Divider(
              height: 48.h,
              thickness: 1.h,
              color: ThemeClass.of(context).alertBackground,
            ),
            ProfileItemWidget(
              onTap: ()=>context.pushNamed(HelpCenterScreen.routeName),
              title: Strings.helpCenter.tr,
              icon: Assets.imagesHelpCenterIc,
              color: const Color.fromRGBO(27, 172, 75, 0.08),
            ),
            Gap(24.h),
            // ProfileItemWidget(
            //   onTap: ()=>context.pushNamed(AboutScreen.routeName),
            //   title: Strings.aboutILibrary.tr,
            //   icon: Assets.imagesAboutIc,
            //   color: const Color.fromRGBO(248, 147, 0, 0.08),
            // ),
            // Gap(24.h),
            ProfileItemWidget(
              onTap: con.onLogOut,
              widget: const SizedBox.shrink(),
              title: Strings.logout.tr,
              icon: Assets.imagesLogoutIc,
              color: ThemeClass.of(context).warningColor.withOpacity(.08),
            ),
            const Spacer(),
            Text("Version 1.0.12",style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),),
          ],
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarWidget(selected: SelectedBottomNavBar.account),
    );
  }
}

class ProfileItemWidget extends StatelessWidget {
  final String title, icon;
  final Color color;
  final Widget? widget;
  final Function()? onTap;

  const ProfileItemWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      this.widget,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: SvgPicture.asset(icon),
          ),
          Gap(20.w),
          Expanded(
              child: Text(
            title,
            style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
          )),
          widget ??
              Icon(
                Icons.arrow_forward_ios,
                color: ThemeClass.of(context).mainTextColor,
                size: 20.r,
              )
        ],
      ),
    );
  }
}
