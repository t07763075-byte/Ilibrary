import 'package:ELibrary/Utilities/bottom_sheet_helper.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:state_extended/state_extended.dart';
import '../Widget/subscription_details_widget.dart';
import 'Widget/subscription_plan_widget.dart';

class MySubscriptionController extends StateXController {
  // singleton
  factory MySubscriptionController() => _this ??= MySubscriptionController._();
  static MySubscriptionController? _this;

  MySubscriptionController._();

  bool loading = true;

  subscriptionDetails() {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: const SubscriptionDetailsWidget(),
      backgroundColor: ThemeClass.of(currentContext_!).cartColor
    );
  }
  subscriptionPlanWidget() {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: const SubscriptionPlanWidget(),
      backgroundColor: ThemeClass.of(currentContext_!).cartColor
    );
  }
}
