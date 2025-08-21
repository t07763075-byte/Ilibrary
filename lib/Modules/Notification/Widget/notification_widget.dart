import 'package:ELibrary/Models/notification_model.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_network_image.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../Utilities/format_date_helper.dart';
import '../../../Utilities/theme_helper.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  const NotificationWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(

          children: [
            CustomNetworkImage(url: notification.icon, width: 56.r, height: 56.r,radius: 1000.r,),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title??'',style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
                  Gap(4.h),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Text(FormatDateHelper.getTimeAgo(notification.creationDate,short: true),style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                          color: ThemeClass.of(context).hintColor,
                        ),),
                        VerticalDivider(
                          thickness: 1.r,
                          endIndent: 2.h,
                          indent: 2.h,
                          width: 16.w,
                          color: ThemeClass.of(context).hintColor,
                        ),
                        Text(FormatDateHelper.formattedTime.format(notification.creationDate??DateTime.now()),style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                          color: ThemeClass.of(context).hintColor,
                        ),),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Gap(12.w),
           if(notification.isSeen) Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 6.h),
              decoration: BoxDecoration(
                color: ThemeClass.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6.r)
              ),
              child: Text(Strings.new_.tr,style: TextStyleHelper.of(context).s10SemiBoldTextStyle,),
            )
          ],
        ),
        Gap(8.h),
        Text(notification.body??'',style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
          color: ThemeClass.of(context).bodyTextColor
        ),)
      ],
    );
  }
}
