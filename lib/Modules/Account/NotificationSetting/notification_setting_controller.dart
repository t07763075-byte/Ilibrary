import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Models/notification_setting_model.dart';

class NotificationSettingController extends StateXController {
  // singleton
  factory NotificationSettingController() => _this ??= NotificationSettingController._();
  static NotificationSettingController? _this;

  NotificationSettingController._();

  bool loading = true;
   List<NotificationSettingModel> notificationSettings = [
    NotificationSettingModel(id: 1, title: Strings.newRecommendation, open: false),
    NotificationSettingModel(id: 2, title: Strings.newBookSeries, open: false),
    NotificationSettingModel(id: 3, title: Strings.authorUpdate, open: false),
    NotificationSettingModel(id: 4, title: Strings.priceDrops, open: false),
    NotificationSettingModel(id: 5, title: Strings.purchaseMade, open: false),
    NotificationSettingModel(id: 6, title: Strings.systemNotifications, open: false),
    NotificationSettingModel(id: 7, title: Strings.newTipsServices, open: false),
    NotificationSettingModel(id: 8, title: Strings.participateSurvey, open: false),
  ];
}
