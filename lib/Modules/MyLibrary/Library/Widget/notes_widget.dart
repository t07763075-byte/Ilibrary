import 'package:ELibrary/Models/book_note_model.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../Utilities/format_date_helper.dart';
import '../../../Book/ReadBook/read_book_screen.dart';
import '../library_controller.dart';

class NotesWidget extends StatelessWidget {
  final BookNoteModel note;
  const NotesWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          ReadBookScreen.routeName,
          pathParameters: {"bookId": note.bookId.toString(), "bookName": note.bookTitle.toString()},
          queryParameters: {"startAt": note.page.toString(),"toNoteId": note.id.toString(),},
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
            color: ThemeClass.of(context).cartColor,
            border: Border.all(
                width: 1.r, color: ThemeClass.of(context).alertBackground),
            borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Text(
                      note.bookTitle??'',
                      style: TextStyleHelper.of(context).s18SemiBoldTextStyle,
                    ),
                  ),
                  Text(
                    note.title ?? '',
                    style: TextStyleHelper.of(context)
                        .s14RegTextStyle
                        .copyWith(color: ThemeClass.of(context).primaryColor),
                  ),
                  Gap(10.h),
                  Text(
                    note.info ?? '',
                    style: TextStyleHelper.of(context)
                        .s14RegTextStyle
                        .copyWith(color: ThemeClass.of(context).lightGreyColor),
                    maxLines: 4,
                  ),
                  Gap(10.h),
                 if(note.date != null) Text(
                    FormatDateHelper.formatWordsNotesDate
                        .format(note.date!),
                    style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                        color: ThemeClass.of(context).shadePrimaryColor),
                  ),
                ],
              ),
            ),
            Gap(16.w),
            InkWell(
              onTap: ()=> LibraryController().onDeleteNote(note),
                child: SvgPicture.asset(Assets.imagesDeleteIc))
          ],
        ),
      ),
    );
  }
}
