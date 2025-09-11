import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_network_image.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../Utilities/enum.dart';
import '../../../../generated/assets.dart';
import '../../../Book/ReadBook/read_book_screen.dart';
import '../library_controller.dart';

class LibraryWidget extends StatelessWidget {
// ignore_for_file: prefer_const_constructors
  final Function(LibraryType) onSelectMenu;
  final LibraryFilterType selectedFilter;
  final BookModel book;

  const LibraryWidget(
      {super.key,
      required this.onSelectMenu,
      required this.selectedFilter,
      required this.book});

  String getReadingStatusText() {
    if (book.isFinished && book.isStartToRead) {
      return Strings.readAgain.tr;
    } else if (!book.isFinished && book.isStartToRead) {
      return Strings.continueReading.tr;
    } else if (!book.isFinished &&
        !book.isStartToRead &&
        selectedFilter == LibraryFilterType.wishlist) {
      return Strings.startRead.tr;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Map<String, dynamic> queryParameters = switch (selectedFilter) {
          LibraryFilterType.myReads => book.isFinished ? {"startAt": "0"} : {},
          LibraryFilterType.bookmarks => {"startAt": book.page.toString()},
          LibraryFilterType.highlights => {
              "startAt": book.page.toString(),
              "toHighlightId": book.bookHighlightId.toString(),
            },
          _ => {}
        };
        context.pushNamed(
          ReadBookScreen.routeName,
          pathParameters: {
            "bookId": book.id.toString(),
            "bookName": book.title.toString()
          },
          queryParameters: queryParameters,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomNetworkImage(
            url: book.imageUrl,
            width: 90.w,
            height: 138.h,
            radius: 6.r,
          ),
          Gap(16.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                book.title ?? "",
                style: TextStyleHelper.of(context)
                    .s18SemiBoldTextStyle
                    .copyWith(height: 1.6),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(12.h),
              if (selectedFilter != LibraryFilterType.highlights)
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: (book.totalRating/5),
                      direction: Axis.horizontal,
                      itemCount: 1,
                      itemSize: 18.r,
                      unratedColor: ThemeClass.of(context).darkGreyColor,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: ThemeClass.of(context).mainTextColor,
                      ),
                    ),
                    Gap(6.w),
                    Text(book.totalRating.toString() ?? '',
                        style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
                        maxLines: 2),
                  ],
                ),
              if (selectedFilter == LibraryFilterType.highlights)
                Text(book.highlightText ?? '',
                    style: TextStyleHelper.of(context)
                        .s14SemiBoldTextStyle
                        .copyWith(color: ThemeClass.of(context).primaryColor),
                    maxLines: 1),
              Gap(14.h),
              Row(
                children: [
                  if (book.page != null)
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: 4.w),
                      child: Text(Strings.page.tr,
                          style: TextStyleHelper.of(context)
                              .s14RegTextStyle
                              .copyWith(
                                  color: ThemeClass.of(context).primaryColor),
                          maxLines: 2),
                    ),
                  if (book.page != null)
                    Text((book.page! + 1).toString() ?? '',
                        style: TextStyleHelper.of(context)
                            .s14RegTextStyle
                            .copyWith(
                                color: ThemeClass.of(context).primaryColor),
                        maxLines: 2),
                  Text(getReadingStatusText(),
                      style: TextStyleHelper.of(context)
                          .s14RegTextStyle
                          .copyWith(color: ThemeClass.of(context).primaryColor),
                      maxLines: 2),
                ],
              ),
              Gap(16.h),
            ],
          )),
          if (selectedFilter == LibraryFilterType.myReads)
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: Row(
                children: [
                  InkWell(
                      onTap: () => LibraryController().onDeleteMyRead(book),
                      child: SvgPicture.asset(
                        Assets.imagesDeleteIc,
                        color: ThemeClass.of(context).warningColor,
                      )),
                  // SvgPicture.asset(Assets.imagesSuccessIc,color: ThemeClass.of(context).primaryColor,),
                  // PopupMenuButton<LibraryType>(
                  //   elevation: 0,
                  //   padding: EdgeInsets.zero,
                  //   offset: Offset(0, 30.h),
                  //   color: const Color(0xff1F222A),
                  //   shape: RoundedRectangleBorder(
                  //
                  //     borderRadius: BorderRadius.circular(4.r),
                  //     side: BorderSide(color: const Color(0xFF1F222A), width: .5.r),
                  //
                  //   ),
                  //   itemBuilder: (context) => <PopupMenuEntry<LibraryType>>[
                  //     PopupMenuItem<LibraryType>(
                  //       value: LibraryType.removeDownload,
                  //       child: Row(
                  //         children: [
                  //           SvgPicture.asset(Assets.imagesDeleteIc,color: ThemeClass.of(context).mainTextColor,),
                  //           Gap(12.w),
                  //           Text(LibraryType.removeDownload.name.tr, style: TextStyleHelper.of(context).s14RegTextStyle),
                  //         ],
                  //       ),
                  //     ),
                  //     PopupMenuItem<LibraryType>(
                  //       value: LibraryType.viewSeries,
                  //
                  //       child: Row(
                  //         children: [
                  //           SvgPicture.asset(Assets.imagesNotesIc),
                  //           Gap(12.w),
                  //           Text(LibraryType.viewSeries.name.tr, style: TextStyleHelper.of(context).s14RegTextStyle),
                  //
                  //         ],
                  //       ),
                  //     ),
                  //     PopupMenuItem<LibraryType>(
                  //       value: LibraryType.markAsFinished,
                  //
                  //       child: Row(
                  //         children: [
                  //           SvgPicture.asset(Assets.imagesMarkFinishedIc),
                  //           Gap(12.w),
                  //           Text(LibraryType.markAsFinished.name.tr, style: TextStyleHelper.of(context).s14RegTextStyle),
                  //
                  //         ],
                  //       ),
                  //     ),
                  //     PopupMenuItem<LibraryType>(
                  //       value: LibraryType.aboutILibrary,
                  //
                  //       child: Row(
                  //         children: [
                  //           SvgPicture.asset(Assets.imagesAboutInfoIc),
                  //           Gap(12.w),
                  //           Text(LibraryType.aboutILibrary.name.tr, style: TextStyleHelper.of(context).s14RegTextStyle),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  //   onSelected: onSelectMenu,
                  //   child: Icon(Icons.more_vert, color: ThemeClass.of(context).mainTextColor, size: 24.r),
                  // )
                ],
              ),
            ),
          if (selectedFilter == LibraryFilterType.bookmarks)
            Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: InkWell(
                      key: const Key('bookmark_delete_icon'),
                    onTap: () => LibraryController().deleteBookMark(book),
                    child: SvgPicture.asset(
                      Assets.imagesBookmarkBoldIc,
                      color: ThemeClass.of(context).primaryColor,
                    ))),
          if (selectedFilter == LibraryFilterType.wishlist && book.inWishlist)
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: InkWell(
                  onTap: () => LibraryController().deleteFromWishlist(book),
                  child: Icon(
                    Icons.favorite,
                    color: ThemeClass.of(context).primaryColor,
                    size: 20.r,
                  )),
            ),
          if (selectedFilter == LibraryFilterType.highlights)
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: InkWell(
                  onTap: () => LibraryController().onDeleteHighLight(book),
                  child: SvgPicture.asset(Assets.imagesDeleteIc)),
            ),
        ],
      ),
    );
  }
}
