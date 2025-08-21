import 'package:ELibrary/Modules/Auth/Login/sign_in_screen.dart';
import 'package:ELibrary/Modules/Auth/Register/sign_up_screen.dart';

import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import 'onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = 'OnboardingScreen';
  const OnboardingScreen({super.key});

  @override
  createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends StateX<OnboardingScreen> {
  _OnboardingScreenState() : super(controller: OnboardingController()) {
    con = OnboardingController();
  }

  late OnboardingController con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesOnboardingBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Expanded(flex: 5,child: SizedBox()),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeClass.of(context).backGroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeClass.of(context).backGroundColor,
                      offset: const Offset(0, -2),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: ThemeClass.of(context).backGroundColor.withOpacity(0.8),
                      offset: const Offset(0, -5),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: ThemeClass.of(context).backGroundColor.withOpacity(1),
                      offset: const Offset(0, -15),
                      blurRadius: 25,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: Strings.welcomeTo.tr,
                          style:
                              TextStyleHelper.of(context).s32SemiBoldTextStyle,
                          children: [
                            TextSpan(
                              text: ' ${Strings.iLibrary.tr} 👋',
                              style: TextStyleHelper.of(context)
                                  .s32SemiBoldTextStyle
                                  .copyWith(
                                    color: ThemeClass.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1,),
                      Text(
                        Strings.welcomeToDesOne.tr,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleHelper.of(context)
                            .s18RegTextStyle
                            .copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(flex: 2,),
                      CustomButtonWidget.primary(
                        title: Strings.getStarted.tr,
                        onTap: () {
                          GoRouter.of(context).pushNamed(SignUpScreen.routeName);
                        },
                      ),
                      const Spacer(flex: 1,),
                      CustomButtonWidget.secondary(
                        title: Strings.alreadyHaveAccount.tr,
                        onTap: () {
                          GoRouter.of(context)
                              .pushNamed(SignInScreen.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
