import 'package:ELibrary/Utilities/bottom_sheet_helper.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:state_extended/state_extended.dart';

import '../Widget/subscription_details_widget.dart';


class BillingHistoryController extends StateXController {
  // singleton
  factory BillingHistoryController() => _this ??= BillingHistoryController._();
  static BillingHistoryController? _this;

  BillingHistoryController._();

  bool loading = true;
  onSearch(String? search) async {
    EasyDebounce.debounce('search', const Duration(milliseconds: 1000),
            () async {
          setState(() => loading = true);
        });
    setState(() => loading = false);
  }
  subscriptionDetails() {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: const SubscriptionDetailsWidget(),
        backgroundColor: ThemeClass.of(currentContext_!).cartColor
    );
  }
}
