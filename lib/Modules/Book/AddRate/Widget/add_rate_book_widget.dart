import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../Utilities/theme_helper.dart';

class AddRateBookWidget extends StatelessWidget {
final BookModel?book;
  const AddRateBookWidget({super.key, this.book, });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 184.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomNetworkImage(url: book?.imageUrl, width: 120.w, height: 184.h,),
          Gap(16.w),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Text(book?.title??'',style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
              height: 1.6
            ),maxLines: 2,),
              Gap(12.h),
              Row(
                children: [
                  RatingBarIndicator(
                    rating:(book?.totalRating??0/5),
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
                  Text(book?.totalRating.toString()??'',style: TextStyleHelper.of(context).s14SemiBoldTextStyle,maxLines: 2),

                ],
              ),
              Gap(12.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: book!.bookCategories.map((item) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: ThemeClass.of(context).alertBackground,
                            ),
                            child: Text(
                              item.name ?? '',
                              style: TextStyleHelper.of(context).s12RegTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // تقصير النص إذا كان طويلًا
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              )
          ],)),


        ],
      ),
    );
  }
}
