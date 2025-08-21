import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
class FormatDateHelper {

  static  final formatDate= DateFormat('d/M/yyyy',SharedPref.getLanguage());
  static  final formatDateMyOrder= DateFormat("d MMMM، hh:mm a",SharedPref.getLanguage());
  static  final formatDayAndDate= DateFormat('EEEE d MMMM',SharedPref.getLanguage());
  static  final formatWordsNotesDate= DateFormat('MMM dd, yyyy',SharedPref.getLanguage());
  static  final formattedTime = DateFormat('hh:mm a');
  static final formatterToApi = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",SharedPref.getLanguage());
  static final formatDateSubscription = DateFormat("MMM dd, yyyy");
  static final formatDateSubscriptionDetails = DateFormat("dd MMMM, yyyy");
  static String getTimeAgo(DateTime? time, {bool short = false}) {
    if (time == null) return "";

    final localTimeZoneOffset = DateTime.now().timeZoneOffset;
    time = time.toUtc().add(localTimeZoneOffset);
    String currentLng = Localizations.localeOf(currentContext_!).languageCode;
    bool isAr = currentLng == "ar";

    timeago.setLocaleMessages(
      "$currentLng${short ? "_short" : ""}",
      (short && isAr)
          ? timeago.ArShortMessages()
          : (short && !isAr)
          ? timeago.EnShortMessages()
          : (isAr)
          ? timeago.ArMessages()
          : timeago.EnMessages(),
    );

    // Format the time difference
    return timeago.format(time, locale: "$currentLng${short ? "_short" : ""}");
  }
  static Future <DateTime?> onPickDate({DateTime? firstDate,DateTime? lastDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: currentContext_!,
      firstDate: firstDate ?? DateTime(1950),
      initialDate: lastDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now(),
      cancelText: Strings.cancel.tr,
      confirmText: Strings.ok.tr,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeClass.of(context).backGroundColor,
              onPrimary: ThemeClass.of(context).mainTextColor,
              onSurface: ThemeClass.of(context).backGroundColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                iconColor: ThemeClass.of(context).backGroundColor,
                overlayColor: ThemeClass.of(context).backGroundColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      return pickedDate;
    }
    return null;
  }
}