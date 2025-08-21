import 'package:flutter/material.dart';
import 'package:rush/responsive/responsive_layout.dart';
import 'ScreenLayout/l_appearance_screen.dart';
import 'ScreenLayout/m_appearance_screen.dart';
import 'ScreenLayout/s_appearance_screen.dart';


class AppearanceScreen extends ResponsiveStatelessMixin {
  static const String routeName = "/theme";
  const AppearanceScreen({Key? key}) : super(key: key);



  @override
  Widget buildLargeScreen(BuildContext context) {
    return const LargeAppearanceScreen();
  }

  @override
  Widget buildMediumScreen(BuildContext context) {
    return const MediumAppearanceScreen();
  }

  @override
  Widget buildSmallScreen(BuildContext context) {
    return const SmallAppearanceScreen();
  }
}
