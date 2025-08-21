import 'package:ELibrary/Utilities/shared_preferences.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../Models/rating_data_model.dart';
import '../../../../Utilities/enum.dart';
import '../../../../Utilities/format_date_helper.dart';
import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Widgets/custom_network_image.dart';

class CommentWidget extends StatelessWidget {
  final RatingDataModel rating;
  final Function() onFavPress ;
  final Function(RatingActionType) ratingAction ;
  const CommentWidget({super.key,required this.onFavPress, required this.rating, required this.ratingAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 382.w,
          padding: EdgeInsets.all(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomNetworkImage(url: rating.user?.photoUrl, width: 48.r, height: 48.r,fit: BoxFit.fill,),
                  Gap(16.w),
                  Expanded(
                    child: Text(
                      rating.user?.name??'',
                      style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                    ),
                  ),
                  Container(
                    width: 74.w,
                    height: 38.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.w),
                      border: Border.all(color: ThemeClass.of(context).primaryColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, size: 16.r,color: ThemeClass.of(context).primaryColor,),
                        Gap(6.w),
                        Text(rating.rating?.toString()??'',style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),),
                      ],
                    ),
                  ),

                  if(rating.user?.id==SharedPref.getCurrentUser()?.id)
                  PopupMenuButton<RatingActionType>(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    offset: Offset(0, 15.h),
                    color: ThemeClass.of(context).alertBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(color: ThemeClass.of(context).alertBackground, width: .5.r),

                    ),
                    itemBuilder: (context) => <PopupMenuEntry<RatingActionType>>[
                      PopupMenuItem<RatingActionType>(
                        value: RatingActionType.edit,
                        child: Text(Strings.edit.tr, style: TextStyleHelper.of(context).s18SemiBoldTextStyle),
                      ),
                      PopupMenuItem<RatingActionType>(
                        value: RatingActionType.delete,
                        child: Text(Strings.delete.tr, style: TextStyleHelper.of(context).s18SemiBoldTextStyle),

                      ),
                    ],
                    onSelected: ratingAction,
                    child: Padding(
                      padding:  EdgeInsetsDirectional.only(start: 12.w),
                      child: Icon(CupertinoIcons.ellipsis_circle, size: 16.r,color: Colors.white,),
                    ),
                  )
                ],
              ),

             if(rating.review!=null&&rating.review!.trim().isNotEmpty) Padding(
               padding:  EdgeInsets.only(top:16.h),
               child: Text(
                  rating.review??'',
                  style: TextStyleHelper.of(context).s16RegTextStyle,
                ),
             ),
              Gap(16.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: ()=> onFavPress(),
                    child: rating.isUserLike? SvgPicture.asset("assets/images/heart.svg",fit: BoxFit.fill,width: 24.w,height: 24.h,) :SvgPicture.asset("assets/images/emptyheart.svg",fit: BoxFit.fill,width: 24.w,height: 24.h,) ,
                  ),
                  Gap(8.w),
                  Text(rating.likes.toString(), style: TextStyleHelper.of(context).s12RegTextStyle),
                  Gap(24.w),
                  Text(FormatDateHelper.getTimeAgo(rating.lastModifiedAt), style: TextStyleHelper.of(context).s12RegTextStyle),
                ],
              ),
            ],
          ),
        ),
        Gap(24.h,)
      ],
    );
  }

}
