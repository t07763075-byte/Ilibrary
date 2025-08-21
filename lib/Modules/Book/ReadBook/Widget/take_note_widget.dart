import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../Utilities/strings.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';

class TakeNoteWidget extends StatelessWidget {
  final Function(String) onSave;
  final String? initialNote;
  TakeNoteWidget({super.key, required this.onSave, this.initialNote}) {
    _noteTextController.text = initialNote??"";
  }

  static final TextEditingController _noteTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(44.r),topRight: Radius.circular(44.r)),
          border: Border(
            top: BorderSide(color: ThemeClass.of(context).alertBackground,),
          )
      ),
      child: Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(8.h),
            Center(
              child: Container(height: 3.h,
                width:38.w ,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: ThemeClass.of(context).alertBackground
                ),),
            ),
            Gap(24.h),
            Text(initialNote == null? Strings.takeNote.tr : Strings.editNote.tr,style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
            Gap(24.h),
            CustomTextFieldWidget(
              minLines: 4,
              maxLine: 5,
              isDense: true,
              hint: Strings.writeNote.tr,
              borderColor: const Color(0xff424242),
              controller: _noteTextController,
            ),
            Gap(24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButtonWidget.secondary(
                    title: Strings.cancel.tr,
                    radius: 100.r,
                    onTap: ()=> context.pop(),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: CustomButtonWidget.primary(
                    title: Strings.save.tr,
                    radius: 100.r,
                    onTap: () {
                      onSave(_noteTextController.text);
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
            Gap(36.h),
          ],
        ),
      ),
    );
  }
}
