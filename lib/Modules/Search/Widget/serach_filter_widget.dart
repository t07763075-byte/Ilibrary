import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../Utilities/text_style_helper.dart';
import '../../../Utilities/theme_helper.dart';
import '../../../generated/assets.dart';
import '../../Home/Filter/filter_provider.dart';
import '../search_controller.dart' as search;

class SearchFilterWidget extends StatelessWidget {
  const SearchFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(builder: (_, provider, child) {
      if(provider.selectedRating==null&&provider.selectedSort==null&&provider.language==null)return const SizedBox.shrink();
      return SizedBox(
        height: 38.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          children: [
           if(provider.selectedSort!=null) Container(
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.5.r,
                      color: ThemeClass.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(100.r)),
              child: Row(
                children: [
                  Text(
                    provider.selectedSort?.name.tr ?? '',
                    style: TextStyleHelper.of(context)
                        .s16SemiBoldTextStyle
                        .copyWith(
                        color: ThemeClass.of(context)
                            .primaryColor),
                  ),
                  Gap(8.w),
                  GestureDetector(
                    onTap: (){provider.resetSort();search.SearchController().getSearchBook(removeOld: true);},
                      child: SvgPicture.asset(Assets.imagesCloseSquareIc))
                ],
              ),
            ),
           if(provider.selectedRating!=null) Container(
              alignment: AlignmentDirectional.center,
              margin: EdgeInsetsDirectional.only(start: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.5.r,
                      color: ThemeClass.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(100.r)),
              child: Row(
                children: [
                  Text(
                    provider.selectedRating?.index==0?provider.selectedRating?.name.tr??'': "${Strings.rating.tr} ${provider.selectedRating?.name.tr ?? ''}",
                    style: TextStyleHelper.of(context)
                        .s16SemiBoldTextStyle
                        .copyWith(
                        color: ThemeClass.of(context)
                            .primaryColor),
                  ),
                  Gap(8.w),
                  GestureDetector(
                    onTap:(){
                      provider.resetRating();
                      search.SearchController().getSearchBook(removeOld: true);
                      },
                      child: SvgPicture.asset(Assets.imagesCloseSquareIc))
                ],
              ),
            ),
           if(provider.language!=null) Container(
              alignment: AlignmentDirectional.center,
             margin: EdgeInsetsDirectional.only(start: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.5.r,
                      color: ThemeClass.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(100.r)),
              child: Row(
                children: [
                  Text(
                    provider.language?.name ?? '',
                    style: TextStyleHelper.of(context)
                        .s16SemiBoldTextStyle
                        .copyWith(
                        color: ThemeClass.of(context)
                            .primaryColor),
                  ),
                  Gap(8.w),
                  GestureDetector(
                    onTap:(){ provider.resetLang();search.SearchController().getSearchBook(removeOld: true);},
                      child: SvgPicture.asset(Assets.imagesCloseSquareIc))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
