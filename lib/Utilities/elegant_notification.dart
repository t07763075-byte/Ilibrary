
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';

class ElegantNotificationHelper{
  static void show({required String message,Widget? leading}) {
    ElegantNotification(
      toastDuration: const Duration(seconds: 2),
      progressIndicatorColor: ThemeClass.of(currentContext_!).primaryColor,
      progressIndicatorBackground: Colors.transparent,
      position: Alignment.topCenter,  // Keep position at top center
      height: 64.h,
      showProgressIndicator: false,
      isDismissable: true,
      description: Text(
        message,
        style: TextStyleHelper.of(currentContext_!).s14RegTextStyle,
      ),
      icon: leading ?? SvgPicture.asset(Assets.imagesSuccessIc),
      displayCloseButton: false,

      background: ThemeClass.of(currentContext_!).alertBackground,
      animation: AnimationType.fromTop,
    ).show(currentContext_!);
  }
}