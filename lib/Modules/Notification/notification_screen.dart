import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import '../../Widgets/pagination_widget.dart';
import 'Widget/notification_widget.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = "Notification";

  const NotificationScreen({super.key});

  @override
  createState() => _NotificationScreenState();
}

class _NotificationScreenState extends StateX<NotificationScreen> {
  _NotificationScreenState() : super(controller: NotificationController()) {
    con = NotificationController();
  }

  late NotificationController con;
@override
  void initState() {
    con.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.notification.tr,
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: PaginationWidget(
          onLoading: con.getData,
          refreshController: con.refreshController,
          refresh: ()=>con.getData(removeOld: true),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
              itemBuilder: (_, index)=>NotificationWidget(notification:con.notificationPagination.data[index]),
              separatorBuilder: (_, __) => Gap(24.h),
              itemCount: con.notificationPagination.data.length),
        ),
      ),
    );
  }
}
