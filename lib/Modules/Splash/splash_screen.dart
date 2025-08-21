import 'package:rush/responsive/responsive_layout.dart';
import 'ScreensLayout/l_splash_screen.dart';
import 'ScreensLayout/m_splash_screen.dart';
import 'ScreensLayout/s_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends ResponsiveStatelessMixin {
  static const routeName = "/";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget buildLargeScreen(BuildContext context) {
    return const LargeSplashScreen();
  }

  @override
  Widget buildMediumScreen(BuildContext context) {
    return const MediumSplashScreen();
  }

  @override
  Widget buildSmallScreen(BuildContext context) {
    return const SmallSplashScreen();
  }
}
