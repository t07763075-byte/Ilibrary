import 'package:ELibrary/Modules/Home/Home/home_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../Modules/Account/Profile/profile_screen.dart';
import '../Modules/MyLibrary/Library/library_screen.dart';
import '../Utilities/strings.dart';
import '../Utilities/text_style_helper.dart';
import '../Utilities/theme_helper.dart';
import '../generated/assets.dart';

class BottomNavBarWidget extends StatelessWidget {
  final SelectedBottomNavBar selected;

  const BottomNavBarWidget({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w,vertical: 16.h),
      alignment: AlignmentDirectional.topStart,
      decoration: BoxDecoration(
        color: ThemeClass.of(context).backGroundColor,
        border:  Border(
          top: BorderSide(
            color: const Color(0xFF424242),
            width: 1.r,
          ),
        ),
      ),
      height: 82.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BottomNavBarItemWidget(model: _BottomNavBarItemModel.home,currentItem: selected),
          _BottomNavBarItemWidget(model: _BottomNavBarItemModel.myLibrary,currentItem: selected),
          _BottomNavBarItemWidget(model: _BottomNavBarItemModel.account,currentItem: selected),
        ],
      ),
    );
  }
}

class _BottomNavBarItemModel {
  final String iconPath;
  final String title;
  final String routeName;
  final SelectedBottomNavBar type;

  _BottomNavBarItemModel(
      {required this.iconPath,
      required this.title,
      required this.type,
      required this.routeName});

  static _BottomNavBarItemModel home = _BottomNavBarItemModel(
    title: Strings.home,
    iconPath: Assets.imagesHomeIc,
    type: SelectedBottomNavBar.home,
    routeName: HomeScreen.routeName,
  );

  static _BottomNavBarItemModel myLibrary = _BottomNavBarItemModel(
    title: Strings.myLibrary,
    iconPath: Assets.imagesLibraryIc,
    type: SelectedBottomNavBar.library,
    routeName:LibraryScreen.routeName,
  );

  static _BottomNavBarItemModel account = _BottomNavBarItemModel(
      title: Strings.account,
      iconPath: Assets.imagesProfileIc,
      type: SelectedBottomNavBar.account,
      routeName:ProfileScreen.routeName);
}

class _BottomNavBarItemWidget extends StatelessWidget {
  final _BottomNavBarItemModel model;
  final SelectedBottomNavBar currentItem;

  const _BottomNavBarItemWidget(
      {Key? key, required this.model, required this.currentItem})
      : super(key: key);

  bool get isSelected => model.type == currentItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(48.r),
      onTap: () {
        if (model.routeName.replaceAll("/", "") !=
            GoRouter.of(context).location.replaceAll("/", "")) {
          while (context.canPop()) {
            context.pop();
          }
          context.pushNamed(
            model.routeName,
          );
        }
      },
      child: Container(
        width: 116.w,
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48.r),
          color: isSelected
              ? ThemeClass.of(context).primaryColor
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              model.iconPath,
              color:isSelected?ThemeClass.of(context).shadePrimaryColor:null ,
            ),
            Gap(6.w),
            Text(
              AppLocalizations.of(context)?.translate(model.title) ?? "",
              style: isSelected
                  ? TextStyleHelper.of(context).s12RegTextStyle.copyWith(
                        color: ThemeClass.of(context).shadePrimaryColor,
                      )
                  : TextStyleHelper.of(context).s12SemiBoldTextStyle.copyWith(
                        color: ThemeClass.of(context).darkGreyColor,
                      ),
            )
          ],
        ),
      ),
    );
  }
}

enum SelectedBottomNavBar { home, library, account }
