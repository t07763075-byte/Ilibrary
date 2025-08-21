import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../Utilities/strings.dart';
import '../../../Utilities/text_style_helper.dart';
import '../../../Utilities/theme_helper.dart';
class BookRatingsReviewsWidget extends StatelessWidget {
  final BookModel? bookData;
  const BookRatingsReviewsWidget({super.key,  this.bookData});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(bookData?.totalRating.toString()??'0.0',style: TextStyleHelper.of(context).s45SemiBoldTextStyle,),
              Gap(8.h),
              RatingBarIndicator(
                rating:(bookData?.totalRating??0/5),
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 24.sp,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              Gap(8.h),
              Text("(${bookData?.totalReviews??0} ${Strings.reviews.tr})",style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
            ],
          ),
          VerticalDivider(
            color: ThemeClass.of(context).alertBackground,
            thickness: 1.w,

          ),

          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "5",
                      style:  TextStyleHelper.of(context).s16SemiBoldTextStyle, // Replace this with your custom style if necessary
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1500,
                        lineHeight: 6.h,
                        barRadius: Radius.circular(16.r),
                        percent:bookData!.totalRatingCount!=0? (bookData!.rating5Count/bookData!.totalRatingCount).clamp(0, 1):0, // Progress percentage
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey[800],
                        progressColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                Row(
                  children: [
                    Text(
                      "4",
                      style:  TextStyleHelper.of(context).s16SemiBoldTextStyle, // Replace this with your custom style if necessary
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1500,
                        lineHeight: 6.h,
                        barRadius: Radius.circular(16.r),
                        percent:bookData!.totalRatingCount!=0? (bookData!.rating4Count/bookData!.totalRatingCount).clamp(0, 1):0, // Progress percentage
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey[800],
                        progressColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                Row(
                  children: [
                    Text(
                      "3",
                      style:  TextStyleHelper.of(context).s16SemiBoldTextStyle, // Replace this with your custom style if necessary
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1500,
                        lineHeight: 6.h,
                        barRadius: Radius.circular(16.r),
                        percent:bookData!.totalRatingCount!=0? (bookData!.rating3Count/bookData!.totalRatingCount).clamp(0, 1):0, // Progress percentage
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey[800],
                        progressColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                Row(
                  children: [
                    Text(
                      "2",
                      style:  TextStyleHelper.of(context).s16SemiBoldTextStyle, // Replace this with your custom style if necessary
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1500,
                        lineHeight: 6.h,
                        barRadius: Radius.circular(16.r),
                        percent:bookData!.totalRatingCount!=0? (bookData!.rating2Count/bookData!.totalRatingCount).clamp(0, 1):0, // Progress percentage
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey[800],
                        progressColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                Row(
                  children: [
                    Text(
                      "1",
                      style:  TextStyleHelper.of(context).s16SemiBoldTextStyle, // Replace this with your custom style if necessary
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1500,
                        lineHeight: 6.h,
                        barRadius: Radius.circular(16.r),
                        percent:bookData!.totalRatingCount!=0? (bookData!.rating1Count/bookData!.totalRatingCount).clamp(0, 1):0, // Progress percentage
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey[800],
                        progressColor: Colors.orange,
                      ),
                    ),
                  ],
                ),

              ]
            ),
          ),
        ],
      ),
    );
  }
}
