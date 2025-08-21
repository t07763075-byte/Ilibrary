import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Modules/Book/BookDetail/book_detail_screen.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../Utilities/text_style_helper.dart';

class VerticalHomeItemWidget extends StatelessWidget {
  final BookModel book;
  const VerticalHomeItemWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>context.pushNamed(BookDetailScreen.routeName,queryParameters:{
      'bookId':book.id.toString()
      }),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomNetworkImage(
              url:
              book.imageUrl,
              width: 120.w,
              height: 184.h),
          Gap(16.w),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                book.title??'',
                style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
                      height: 1.6.h,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(14.h),
              Row(
                children: [
                  RatingBarIndicator(
                    rating:(book.totalRating/5),
                    direction: Axis.horizontal,
                    itemCount: 1,
                    itemSize: 18.r,
                    unratedColor:ThemeClass.of(context).darkGreyColor,
                    itemBuilder: (context, _) =>  Icon(
                      Icons.star,
                      color: ThemeClass.of(context).mainTextColor,
                    ),
                  ),
                  Gap(6.w),
                  Text(book.totalRating.toString(),style: TextStyleHelper.of(context).s14SemiBoldTextStyle,maxLines: 2),
                ],
              ),
              Gap(14.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: book.bookCategories.take(4).map((e){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 6.h),
                    decoration: BoxDecoration(
                      color: ThemeClass.of(context).alertBackground,
                      borderRadius: BorderRadius.circular(6.r)
                    ),
                    child: Text(e.nameAfterSplit??'',style: TextStyleHelper.of(context).s10SemiBoldTextStyle,),
                  );
                }).toList(),
              )
            ],
          ))
        ],
      ),
    );
  }
}
