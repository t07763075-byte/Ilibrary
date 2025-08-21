import 'package:ELibrary/Utilities/router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../../Utilities/bottom_sheet_helper.dart';
import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../core/Language/locales.dart';
import '../../../../generated/assets.dart';
import 'more_options_widget.dart';
import '../read_book_controller.dart';

class ReadBookNavBarWidget extends StatelessWidget {
  final bool isCurrentBookMarked;
  const ReadBookNavBarWidget({super.key, required this.isCurrentBookMarked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 18.w),
      decoration: BoxDecoration(
        color: ThemeClass
            .of(context)
            .backGroundColor,
        border: Border(
          top: BorderSide(
            color: const Color(0xFF424242),
            width: 1.r,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BottomNavBarItemWidget(model:_ReadBookBottomNavBarItemModel.highlights),
          _BottomNavBarItemWidget(model:_ReadBookBottomNavBarItemModel.notes),
          _BottomNavBarItemWidget(
            model:_ReadBookBottomNavBarItemModel.bookmark.copyWith(
              iconPath: isCurrentBookMarked ? Assets.imagesBookmarkBoldIc : null,
              textColor: isCurrentBookMarked ? ThemeClass.of(context).primaryColor : null,
            ),
          ),
          _BottomNavBarItemWidget(model:_ReadBookBottomNavBarItemModel.moreOptions),

        ],
      ),
    );
  }
}

class _ReadBookBottomNavBarItemModel {
  final String iconPath;
  final String title;
  final Color? textColor;
  final Function() onTap;
  final ReadBookSelectedBottomNavBar type;

  _ReadBookBottomNavBarItemModel({required this.iconPath,
    required this.title,
    required this.type,
    required this.onTap,
    this.textColor,
  });

  _ReadBookBottomNavBarItemModel copyWith({String? iconPath,String? title,Color? textColor}){
    return _ReadBookBottomNavBarItemModel(
      iconPath: iconPath ?? this.iconPath,
      title: title ?? this.title,
      textColor: textColor ?? this.textColor,
      type: type,
      onTap: onTap,
    );
  }

  static _ReadBookBottomNavBarItemModel highlights = _ReadBookBottomNavBarItemModel(
    title: Strings.highlights,
    iconPath: Assets.imagesHighlightsIc,
    type: ReadBookSelectedBottomNavBar.highlights,
    onTap: ReadBookController().openHighLightsList,
  );

  static _ReadBookBottomNavBarItemModel notes = _ReadBookBottomNavBarItemModel(
    title: Strings.notes,
    iconPath: Assets.imagesNotesIc,
    type: ReadBookSelectedBottomNavBar.notes,
    onTap: ReadBookController().openNotesList,
  );

  static _ReadBookBottomNavBarItemModel bookmark = _ReadBookBottomNavBarItemModel(
    title: Strings.bookmark,
    iconPath: Assets.imagesBookmarkIc,
    type: ReadBookSelectedBottomNavBar.bookmark,
    onTap: ReadBookController().onBookmarkChange,
  );
  static _ReadBookBottomNavBarItemModel moreOptions = _ReadBookBottomNavBarItemModel(
    title: Strings.moreOptions,
    iconPath: Assets.imagesMoreOptionsIc,
    type: ReadBookSelectedBottomNavBar.moreOptions,
    onTap: ()=> BottomSheetHelper.bottomSheet(context: currentContext_!, widget: const MoreOptionsWidget(),),
  );
}

class _BottomNavBarItemWidget extends StatelessWidget {
  final _ReadBookBottomNavBarItemModel model;


  const _BottomNavBarItemWidget({Key? key,
    required this.model})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(48.r),
      onTap: model.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48.r),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              model.iconPath,
            ),
            Gap(2.w),
            Text(
                AppLocalizations.of(context)?.translate(model.title) ?? "",
                style: TextStyleHelper.of(context).s12RegTextStyle.copyWith(color: model.textColor)
            ),
          ],
        ),
      ),
    );
  }
}
enum ReadBookSelectedBottomNavBar { highlights, notes, bookmark, moreOptions }