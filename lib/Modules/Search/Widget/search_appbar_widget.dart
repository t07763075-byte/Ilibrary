import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../Utilities/router_helper.dart';
import '../../../Utilities/theme_helper.dart';

class SearchAppbarWidget extends StatelessWidget implements PreferredSizeWidget{
  final Function(String?)onSearch;
  final TextEditingController searchController;
  const SearchAppbarWidget({super.key, required this.onSearch, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4.h,
          left: 24.w,
          right: 24.w,
          bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: ()=> RouterHelper.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: ThemeClass.of(context).mainTextColor,
              )),
          Gap(16.w),
          Expanded(child: CustomTextFieldWidget(
            controller: searchController,
            backGroundColor: ThemeClass.of(context).cartColor,
            borderColor: ThemeClass.of(context).cartColor,
            insidePadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
            style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
            isDense: true,
            // suffixIcon: Padding(
            //   padding:  EdgeInsetsDirectional.only(end: 20.w),
            //   child: SvgPicture.asset(Assets.imagesFilterIc,color: ThemeClass.of(context).primaryColor,),
            // ),
            prefixIcon: Padding(
              padding:  EdgeInsetsDirectional.only(start: 12.w,end: 12.w),
              child: SvgPicture.asset(Assets.imagesSearchIc,height: 20.r,),
            ),
            onchange: onSearch,
          ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(86.h);
}
