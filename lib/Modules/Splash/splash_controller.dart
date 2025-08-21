import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:state_extended/state_extended.dart';
import '../../core/network/internet_connection_provider.dart';
import '../Auth/Onboarding/onboarding_screen.dart';
import '../Home/Home/home_screen.dart';
import '../MyLibrary/Library/library_screen.dart';

class SplashController extends StateXController {
  // singleton
  factory SplashController() => _this ??= SplashController._();
  static SplashController? _this;
  SplashController._();



  Future init(BuildContext context)async{
    await Future.delayed(const Duration(seconds: 2));
    if(context.mounted) {
      final internetConnectionProvider = Provider.of<InternetConnectionProvider>(context,listen: false);
      String initRouteName = OnboardingScreen.routeName;

      if(SharedPref.isLogin && internetConnectionProvider.isConnected) initRouteName = HomeScreen.routeName;
      if(SharedPref.isLogin && !internetConnectionProvider.isConnected) initRouteName = LibraryScreen.routeName;

      GoRouter.of(context).goNamed(initRouteName);
    }
  }
}
