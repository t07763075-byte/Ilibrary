import 'package:ELibrary/Utilities/bottom_sheet_helper.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:state_extended/state_extended.dart';
import '../LogOut/logout_screen.dart';

class ProfileController extends StateXController {
  // singleton
  factory ProfileController() => _this ??= ProfileController._();
  static ProfileController? _this;

  ProfileController._();

  bool isDarkMode = true;


  onLogOut() {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        onDismiss: () {
          setState(() {});
        },
        widget: LogoutScreen());
  }
}
