import 'package:state_extended/state_extended.dart';

class OnboardingController extends StateXController {
  // singleton
  static OnboardingController? _this;
  OnboardingController._();
  factory OnboardingController() => _this ??= OnboardingController._();



}
