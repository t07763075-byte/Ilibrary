import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../Utilities/strings.dart';
import '../Utilities/text_style_helper.dart';
import '../Utilities/theme_helper.dart';
import '../generated/assets.dart';
class ShowInWidget extends StatelessWidget {
  final bool isGridView,openSearch;
  final Function()onGridView,onListScrollIc;
  final Function(String)? onchange;
  const ShowInWidget({super.key, required this.isGridView, required this.onGridView, required this.onListScrollIc,this.openSearch=false, this.onchange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [

         if(openSearch) Padding(
           padding:  EdgeInsets.only(bottom: 16.h),
           child: CustomTextFieldWidget(
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
             onchange: onchange,
           ),
         ),

          Row(
            children: [
              Expanded(
                  child: Text(
                    Strings.showIn.tr,
                    style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                  )),
              GestureDetector(
                  onTap: onGridView,
                  child: SvgPicture.asset(
                    Assets.imagesLanguageIc,
                    color: isGridView
                        ? ThemeClass.of(context).primaryColor
                        : ThemeClass.of(context).borderColor,
                  )),
              Gap(20.w),
              GestureDetector(
                  onTap: onListScrollIc,
                  child: SvgPicture.asset(
                    Assets.imagesListScrollIc,
                    color: !isGridView
                        ? ThemeClass.of(context).primaryColor
                        : ThemeClass.of(context).borderColor,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
