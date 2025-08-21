import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetHelper {
  static Future bottomSheet({
    required BuildContext context,
    required Widget widget,
    Widget Function(BuildContext)? builder,
     double? radius,
    Function? onDismiss,
    Color? backgroundColor,
    bool isDismissible=true,
  }) async {
    await showModalBottomSheet(
      isDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius??44.r))),
      backgroundColor:backgroundColor?? ThemeClass.of(context).backGroundColor,
      context: context,
      isScrollControlled: true,
      builder: builder ?? (BuildContext context) => widget,
    ).then((_) {
      if (onDismiss != null) onDismiss();
    });
  }
}


class BottomSheetVisibilityProvider extends ChangeNotifier {

  bool _isOpened = false;

  bool get isOpen => _isOpened;

  void updateBottomSheetVisibility(bool isOpen){
    if(isOpen == _isOpened) return;
    _isOpened = isOpen;
    notifyListeners();
  }


}