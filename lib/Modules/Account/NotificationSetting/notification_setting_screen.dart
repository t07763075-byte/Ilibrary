import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/strings.dart';
import '../../../Widgets/custom_appbar_widget.dart';
import '../../../Widgets/custom_switch_widget.dart';
import 'notification_setting_controller.dart';

class NotificationSettingScreen extends StatefulWidget {
  static const routeName="NotificationSetting";
  const NotificationSettingScreen({super.key});

  @override
   createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends StateX<NotificationSettingScreen> {
  _NotificationSettingScreenState():super(controller: NotificationSettingController()){
    con=NotificationSettingController();
  }
  late NotificationSettingController con;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  CustomAppBarWidget.mainDetailsScreen(
        screenName: Strings.notification.tr,
        showFavorite: false,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
        children: [
          Text(Strings.notifyMe.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,),
          Gap(32.h),
          ...con.notificationSettings.map((item){
            return Padding(
              padding:  EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                children: [
                  Expanded(child: Text(item.title.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,)),
                  CustomSwitchWidget(
                    value: item.open,
                    onChanged: (bool value) {
                      setState(() {
                        item.open = value;
                      });
                    },
                  )
                ],
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}
