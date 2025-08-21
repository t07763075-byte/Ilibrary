import 'package:ELibrary/Models/book_highlight_model.dart';
import 'package:ELibrary/Models/book_note_model.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../Models/book_text_address.dart';
import '../../../../Utilities/format_date_helper.dart';
import '../../../../Utilities/router_config.dart';
import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../generated/assets.dart';

class ActionsListWidget<T extends BookTextAddress> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Function(T) onDelete,onSelect;
  const ActionsListWidget({super.key, required this.title, required this.items, required this.onDelete, required this.onSelect,});


  Widget actionBuilder(int index){
    return switch(T){
      BookHighlightModel => HighLightWidget(
        highlightModel: items[index] as BookHighlightModel,
        onDelete: () {
          currentContext_?.pop();
           onDelete(items[index]);
        },
      ),
      BookNoteModel => NoteWidget(
        noteModel: items[index] as BookNoteModel,
        onDelete: () {
          currentContext_?.pop();
          onDelete(items[index]);
        },
      ),
      _=> const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: ThemeClass.of(context).backGroundColor,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Gap(52.h),
                Text(title,style: TextStyleHelper.of(context).s24SemiBoldTextStyle,),
                Gap(12.h),
                Divider(
                  height: 0,
                  thickness: 1.h,
                  color: ThemeClass.of(context).alertBackground,
                ),
                Gap(12.h),
                Expanded(
                  child: ListView.separated(
                    padding:EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (_,index)=> InkWell(
                      onTap: ()=> onSelect(items[index]),
                      child: actionBuilder(index),
                    ),
                    separatorBuilder: (_,i)=> Divider(height: 24.h, thickness: 1.h, color: ThemeClass.of(context).alertBackground,),
                  ),
                ),
                Gap(12.h),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: ()=> context.pop(),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states)=> Colors.transparent,
          ),
          child: SizedBox(
            width: 110.w,
            height: double.infinity,
          ),
        ),
      ],
    );
  }
}

class HighLightWidget extends StatelessWidget {
  final BookHighlightModel highlightModel;
  final Function() onDelete;
  const HighLightWidget({super.key, required this.onDelete, required this.highlightModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(highlightModel.title??"",style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                    color: ThemeClass.of(context).primaryColor
                ),),
                Gap(10.h),
                Text("${FormatDateHelper.formatWordsNotesDate.format(highlightModel.date??DateTime.now())}, ${Strings.page.tr} ${highlightModel.pageNumber??"-"}",style: TextStyleHelper.of(context).s14RegTextStyle,),
              ],
            ),
          ),
          InkWell(onTap: onDelete,child: SvgPicture.asset(Assets.imagesDeleteIc)),
        ],
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  final BookNoteModel noteModel;
  final Function() onDelete;

  const NoteWidget({super.key, required this.onDelete, required this.noteModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(noteModel.title??"",style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                    color: ThemeClass.of(context).primaryColor
                ),),
                Gap(10.h),
                Text(noteModel.info??"",style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(color: ThemeClass.of(context).lightGreyColor),),
                Gap(10.h),
                Text("${FormatDateHelper.formatWordsNotesDate.format(noteModel.date??DateTime.now())}, ${Strings.page.tr} ${noteModel.pageNumber??"-"}",style: TextStyleHelper.of(context).s14RegTextStyle,),
              ],
            ),
          ),
          InkWell(onTap: onDelete,child: SvgPicture.asset(Assets.imagesDeleteIc)),
        ],
      ),
    );
  }
}


