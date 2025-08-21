import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../Models/book_note_model.dart';
import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../read_book_controller.dart';

class NoteDetailsWidget extends StatelessWidget {
  final BookNoteModel note;
  final Function() onEdit;

  const NoteDetailsWidget({super.key, required this.note, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Image.asset(Assets.imagesNoteDetailsIc),
            Padding(
              padding:  EdgeInsetsDirectional.only(top: 60.h,start: 70.w,end: 60.w),
              child: Text(note.info??'',style: TextStyleHelper.of(context).s18RegTextStyle.copyWith(
                color: ThemeClass.of(context).backGroundColor,
                height: 2
              ),
              ),
            )
          ],
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 40.w),
          child: Row(
            children: [
              Expanded(
                child: CustomButtonWidget.customPrimary(
                  onTap:(){
                    context.pop();
                    ReadBookController().onDeleteNote(note);
                  },
                  backgroundColor: ThemeClass.of(context).warningColor,
                  child: Text(Strings.delete.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: CustomButtonWidget.primary(
                  title: Strings.edit.tr,
                  onTap: onEdit,
                ),
              ),
            ],
          ),
        ),
        Gap(32.h),
      ],);
  }
}
