import 'package:ELibrary/Models/notification_model.dart';
import 'package:ELibrary/Modules/Notification/notification_data_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:state_extended/state_extended.dart';

import '../../Models/generic_pagination_model.dart';
import '../../Utilities/toast_helper.dart';

class NotificationController extends StateXController {
  // singleton
  factory NotificationController() => _this ??= NotificationController._();
  static NotificationController? _this;

  NotificationController._();
  bool loading=false;
  GenericPaginationModel<NotificationModel> notificationPagination =
  GenericPaginationModel<NotificationModel>();
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  init() {

    notificationPagination =
        GenericPaginationModel<NotificationModel>();
    getData();
  }
  getData({bool removeOld = false}) async {
    if (removeOld) notificationPagination = GenericPaginationModel<NotificationModel>();

    setState(() {
      loading = true;
    });
    final result =
    await NotificationDataHandler.getData(oldPagination: notificationPagination);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = notificationPagination.data;
      notificationPagination = r;
      if (!removeOld) notificationPagination.data.insertAll(0, oldItems);
    });
    if (!notificationPagination.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }
}
