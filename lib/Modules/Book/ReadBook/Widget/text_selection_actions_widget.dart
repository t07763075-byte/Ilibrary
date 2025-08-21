import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/core/network/internet_connection_provider.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class BookDialogActionsWidget extends StatefulWidget {
  final Function() onAddNote,onTranslate,onExplain,onDefinition;
  final Function(String) onHighlight;
  final bool showWordDefinition;
  const BookDialogActionsWidget({super.key, required this.onHighlight, required this.onAddNote, required this.onTranslate, required this.onExplain, required this.showWordDefinition, required this.onDefinition});

  @override
  State<BookDialogActionsWidget> createState() => _BookDialogActionsWidgetState();
}

class _BookDialogActionsWidgetState extends State<BookDialogActionsWidget> {

  bool highLiteOpen = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100.r),
      color: Colors.transparent,
      child: Container(
        height: 32.h,
        decoration: BoxDecoration(
          color: const Color(0xff212121),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: ThemeClass.of(context).primaryColor,width: 1.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(!highLiteOpen)
              InkWell(onTap: ()=> setState(() => highLiteOpen = true),child: SvgPicture.asset(Assets.imagesHighlite)),
            if(highLiteOpen)
              InkWell(
                onTap: ()=> setState(() => highLiteOpen = false),
                child: Icon(Icons.highlight_remove,size: 24.w,color: Colors.white,),
              ),
            if(highLiteOpen)
              ...["#FF4081","#4AAF57","#00A9F1"].map((e)=> InkWell(
                onTap: ()=> widget.onHighlight(e),
                child: Container(
                  width: 18.r,
                  height: 18.r,
                  margin: EdgeInsetsDirectional.only(start: 16.w),
                  decoration: BoxDecoration(color: hexToColor(e), shape: BoxShape.circle),
                ),
              )).toList(),

            Gap(16.w),
            InkWell(onTap: widget.onAddNote,child: SvgPicture.asset(Assets.imagesNote)),
            if(deviceHaveInternet) Gap(16.w),
            if(deviceHaveInternet) InkWell(onTap: widget.onTranslate,child: SvgPicture.asset(Assets.imagesTranslate)),
            if(deviceHaveInternet) Gap(16.w),
            if(widget.showWordDefinition && deviceHaveInternet) InkWell(onTap: widget.onDefinition,child: SvgPicture.asset(Assets.imagesDefinition)),
            if(widget.showWordDefinition && deviceHaveInternet) Gap(16.w),
            if(deviceHaveInternet) Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: VerticalDivider(color: const Color(0xff616161),thickness: 1.5.w,width: 1.5.w,endIndent: 0,indent: 0,),
            ),
            if(deviceHaveInternet) Gap(16.w),
            if(deviceHaveInternet) InkWell(onTap: widget.onExplain,child: Text(Strings.explain.tr,style: TextStyleHelper.of(context).s12RegTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),)),
          ],
        ),
      ),
    );
  }
  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add full opacity if no alpha is provided
    }
    return Color(int.parse('0x$hexColor'));
  }
}
