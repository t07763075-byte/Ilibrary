import 'dart:convert';

import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../Modules/Home/Filter/filter_screen.dart';
import '../Modules/Notification/notification_screen.dart';
import '../Modules/Search/search_screen.dart';
import '../Utilities/bottom_sheet_helper.dart';
import '../Utilities/router_helper.dart';
import '../generated/assets.dart';

enum _AppbarType { main, mainDetails, details }

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final _AppbarType _appBarType;
  final bool _showFavorite;
  final bool _showShare;
  final bool _showSearch;
  final bool _isFavorite;
  final bool _showFilter;
  final bool _showArrowBack;
  final bool _showNotification;
  final String? _screenName;
  final Function()? _onFavorite, _onAddRate,_onSearch;

  const CustomAppBarWidget.mainScreen({
    Key? key,
    bool showFilter = true,
    bool showNotification = true,
    bool showSearch = true,
  })  : _showSearch = showSearch,
        _showArrowBack = false,
        _onFavorite = null,
        _onSearch = null,
        _onAddRate = null,
        _showNotification = showNotification,
        _showFilter = showFilter,
        _appBarType = _AppbarType.main,
        _showFavorite = false,
        _showShare = false,
        _isFavorite = false,
        _screenName = null,
        super(key: key);

  const CustomAppBarWidget.detailsScreen(
      {Key? key,
      String? screenName,
      bool showArrowBack = true,
      bool showSearch = false,
        Function()? onSearch,
      bool showFilter = false})
      : _showSearch = showSearch,
        _onSearch = onSearch,
        _showArrowBack = showArrowBack,
        _onFavorite = null,
        _onAddRate = null,
        _showNotification = false,
        _isFavorite = false,
        _showFilter = showFilter,
        _appBarType = _AppbarType.details,
        _showFavorite = false,
        _screenName = screenName,
        _showShare = false,
        super(key: key);

  const CustomAppBarWidget.mainDetailsScreen(
      {Key? key,
      String? screenName,
      bool showFavorite = true,
      bool isFavorite = false,
      Function()? onFavorite,
      Function()? onAddRate,

      bool showShare = false})
      : _showSearch = false,
        _showArrowBack = false,
        _onSearch = null,
        _isFavorite = isFavorite,
        _onFavorite = onFavorite,
        _onAddRate = onAddRate,
        _showNotification = false,
        _showFilter = false,
        _appBarType = _AppbarType.mainDetails,
        _showFavorite = showFavorite,
        _screenName = screenName,
        _showShare = showShare,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_appBarType) {
      case _AppbarType.main:
        return _MainAppBarWidget(
          showFilter: _showFilter,
          showNotification: _showNotification,
          showSearch: _showSearch,
        );
      case _AppbarType.mainDetails:
        return _MainDetailsAppBarWidget(
          showFavorite: _showFavorite,
          showShare: _showShare,
          screenName: _screenName,
          onFavorite: _onFavorite,
          isFavorite: _isFavorite,
          onAddRate: _onAddRate,

        );
      case _AppbarType.details:
        return _DetailsAppBarWidget(
          screenName: _screenName,
          showArrowBack: _showArrowBack,
          showSearch: _showSearch,
          showFilter: _showFilter,
          onSearch: _onSearch,
        );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(86.h);
}

class _MainAppBarWidget extends StatelessWidget {
  final bool showFilter, showNotification,showSearch;

  const _MainAppBarWidget(
      {Key? key, required this.showFilter, required this.showNotification,required this.showSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4.h,
          left: 24.w,
          right: 24.w,
          bottom: 16.h),
      child: Row(
        children: [
          SvgPicture.asset(Assets.imagesLogoIc),
          const Spacer(),
          if (showNotification)
            GestureDetector(
                onTap: () => context.pushNamed(NotificationScreen.routeName),
                child: SvgPicture.asset(Assets.imagesNotificationIc)),
          Gap(20.w),
          if (showFilter)
            GestureDetector(
              onTap: ()=> BottomSheetHelper.bottomSheet(context: context, widget: const FilterScreen()),
              child: SvgPicture.asset(Assets.imagesFilterIc),
            ),
          Gap(20.w),
          if(showSearch)
          GestureDetector(
              onTap: () => context.pushNamed(SearchScreen.routeName,queryParameters: {'showPreviousSearch':base64Url.encode(utf8.encode('true'))}),
              child: SvgPicture.asset(Assets.imagesSearchIc,)),
        ],
      ),
    );
  }
}

class _MainDetailsAppBarWidget extends StatelessWidget {
  final bool showFavorite, showShare, isFavorite;
  final String? screenName;
  final Function()? onFavorite, onAddRate;

  const _MainDetailsAppBarWidget({
    Key? key,
    required this.showFavorite,
    required this.showShare,
    this.screenName,
    this.onFavorite,
    this.onAddRate,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4.h,
          left: 24.w,
          right: 24.w,
          bottom: 16.h),
      child: Row(
        children: [
          InkWell(
              onTap: ()=> RouterHelper.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: ThemeClass.of(context).mainTextColor,
              )),
          Gap(16.w),
          Text(
            screenName ?? '',
            style: TextStyleHelper.of(context).s24SemiBoldTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (onAddRate != null)
            InkWell(
                onTap: onAddRate,
                child: Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 1.5.r,
                          color: ThemeClass.of(context).mainTextColor)),
                  child: Icon(
                    Icons.more_horiz,
                    size: 16.r,
                    color: ThemeClass.of(context).mainTextColor,
                  ),
                )),
          if (showFavorite && !isFavorite)
            InkWell(
                onTap: onFavorite,
                child: Icon(
                  CupertinoIcons.heart,
                  size: 24.r,
                  color: ThemeClass.of(context).mainTextColor,
                )),
          if (isFavorite)
            InkWell(
                onTap: onFavorite,
                child: Icon(
                  CupertinoIcons.heart_fill,
                  size: 24.r,
                  color: ThemeClass.of(context).primaryColor,
                )),
          if (showShare)
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.w),
              child: SvgPicture.asset(Assets.imagesSendIc),
            ),
        ],
      ),
    );
  }
}

class _DetailsAppBarWidget extends StatelessWidget {
  final String? screenName;
  final bool showArrowBack, showSearch, showFilter;
final Function()?onSearch;
  const _DetailsAppBarWidget(
      {Key? key,
      this.screenName,
      this.onSearch,
      this.showArrowBack = true,
      this.showSearch = false,
      this.showFilter = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4.h,
          left: 24.w,
          right: 24.w,
          bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (showArrowBack)
            InkWell(
                onTap: ()=> RouterHelper.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: ThemeClass.of(context).mainTextColor,
                )),
          if (!showArrowBack) SvgPicture.asset(Assets.imagesLogoIcon),
          Gap(16.w),
          Expanded(
              child: Text(
            screenName ?? '',
            style: TextStyleHelper.of(context).s24SemiBoldTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          if (showSearch)
            GestureDetector(
                onTap:onSearch?? () => context.pushNamed(SearchScreen.routeName,queryParameters: {'showPreviousSearch':base64Url.encode(utf8.encode('true'))}),
                child: SvgPicture.asset(Assets.imagesSearchIc)),
          // if (showFilter)
          //   Padding(
          //     padding: EdgeInsetsDirectional.only(start: 16.w),
          //     child: SvgPicture.asset(Assets.imagesFilterIc),
          //   )
        ],
      ),
    );
  }
}
