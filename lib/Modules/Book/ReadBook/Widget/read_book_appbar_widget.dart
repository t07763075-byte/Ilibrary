import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../../Utilities/router_helper.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../generated/assets.dart';

class ReadBookAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? screenName;
  final Function()onTap;
  final bool isVertical;
  final bool isDownloaded;
  final Function() onDownloadTap;
  const ReadBookAppbarWidget({super.key, this.screenName, required this.onTap, required this.isVertical, required this.isDownloaded, required this.onDownloadTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6.h, left: 16.w, right: 16.w, bottom: 12.h),
          child: Row(
            children: [
              InkWell(
                onTap: ()=> RouterHelper.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: ThemeClass.of(context).mainTextColor,
                  size: 32.r,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Text(
                  screenName ?? '',
                  style: TextStyleHelper.of(context).s24SemiBoldTextStyle.copyWith(height: 1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(12.w),
              if(!kIsWeb) InkWell(
                onTap: onDownloadTap,
                child: SvgPicture.asset(
                  isDownloaded ? Assets.imagesDeleteIc : Assets.imagesDownload,
                  width: 32.r,height: 32.r,),
              )
              // SvgPicture.asset(Assets.imagesSearchIc,width: 32.r,height: 32.r,),
              // Gap(8.w),
              // InkWell(
              //   onTap: onTap,
              //   child: SvgPicture.asset(isVertical?Assets.imagesVerticalScrollIc:Assets.imagesHorizontalScrollIc,width: 32.r,height: 32.r,),
              // )
            ],
          ),
        ),
        Divider(
          height: 0,
          thickness: .1.h,
          color: ThemeClass.of(context).bodyTextColor,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
