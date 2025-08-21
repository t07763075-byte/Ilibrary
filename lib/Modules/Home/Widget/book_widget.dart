import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../Utilities/theme_helper.dart';
import '../../../Widgets/custom_network_image.dart';
import '../../Book/BookDetail/book_detail_screen.dart';

class BookWidget extends StatelessWidget {
  final BookModel book;
  final double?width,height;
  const BookWidget({super.key, this.width, required this.book, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(BookDetailScreen.routeName,queryParameters:{
        'bookId':book.id.toString()
      }),
      child: SizedBox(
        width:width?? 180.w,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: CustomNetworkImage(url:book.imageUrl, width:width?? 180.w, height: height??276.h,radius: 12.r,fit: BoxFit.cover,)),
            Gap(6.h),
            Text(book.title??'',style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(
              height: 1.39.h,
            ),maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Gap(6.h),
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
                Text(book.totalRating.toString(),style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
                    maxLines: 2,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
