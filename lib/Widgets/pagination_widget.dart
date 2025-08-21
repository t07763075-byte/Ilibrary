import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Utilities/theme_helper.dart';

class PaginationWidget extends StatelessWidget {
  final RefreshController refreshController;
  final Widget child;
  final Function() refresh,onLoading;
  const PaginationWidget({super.key,required this.child,
    required this.refreshController, required this.refresh, required this.onLoading});

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context,LoadStatus? mode){
          Widget child = switch(mode){
            LoadStatus.idle=>  Text(Strings.pullUpLoad.tr,style: TextStyleHelper.of(context).s12RegTextStyle,),
            LoadStatus.loading=>  SpinKitFadingCircle(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:  ThemeClass.of(context).primaryColor,

                  ),
                );
              },
            ),
            LoadStatus.failed=>Text(Strings.loadFailed.tr,style: TextStyleHelper.of(context).s12RegTextStyle,),
            LoadStatus.canLoading=>Text(Strings.releaseToLoadMore.tr,style: TextStyleHelper.of(context).s12RegTextStyle,),
            LoadStatus.noMore=> const SizedBox(),
            null=> const SizedBox(),
          };
          return SizedBox(
            height: 48.h,
            child: Center(child: child),
          );
        },
      ),
      controller: refreshController,
      onRefresh: refresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
