import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Widgets/custom_network_image.dart';
import '../../../../generated/assets.dart';
import '../../../Book/ReadBook/read_book_screen.dart';
import '../library_controller.dart';

class DownloadsWidget extends StatelessWidget {
  final BookModel book;
  const DownloadsWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(ReadBookScreen.routeName, pathParameters: {"bookId": book.id.toString(), "bookName": book.title.toString()},),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            url: book.imageUrl,
            fit: BoxFit.fill,
            width: 100.w,
            height: 120.h,
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
                    style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(height: 1.6),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(12.h),
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
                      Text(book.totalRating.toString(),
                          style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
                          maxLines: 2),
                      Gap(12.w),
                      Text("( ${book.totalRatingCount} )",
                          style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
                          maxLines: 2),
                    ],
                  ),
                  Gap(16.h),
                ],
              )),
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => LibraryController().onDeleteDownloadedBook(book.id!),
                    child: SvgPicture.asset(
                      Assets.imagesDeleteIc,
                      colorFilter: ColorFilter.mode(ThemeClass.of(context).warningColor, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
