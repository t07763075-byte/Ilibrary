import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import '../../Auth/Onboarding/onboarding_screen.dart';

class LogoutController extends StateXController {
  // singleton
  factory LogoutController() => _this ??= LogoutController._();
  static LogoutController? _this;

  LogoutController._();

  bool loading = true;

  static Future logOut()async {
    await SharedPref.logout();
    currentContext_!.goNamed(OnboardingScreen.routeName);
  }
}
