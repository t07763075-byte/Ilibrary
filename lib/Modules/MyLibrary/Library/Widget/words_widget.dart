import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../Models/definition_model.dart';
import '../../../../Utilities/format_date_helper.dart';
import '../../../../Utilities/router_helper.dart';
import '../../Definition/definition_screen.dart';
import '../library_controller.dart';

class WordsWidget extends StatelessWidget {
  final DefinitionModel definition;
  const WordsWidget({super.key, required this.definition});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(DefinitionScreen.routeName, queryParameters: RouterHelper.encode(definition.toJson())),
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
                  Text(
                    definition.word??'',
                    style: TextStyleHelper.of(context)
                        .s14RegTextStyle
                        .copyWith(color: ThemeClass.of(context).primaryColor),
                  ),
                  Gap(10.h),
                  Text(
                    definition.definitions.firstOrNull??'',
                    style: TextStyleHelper.of(context)
                        .s14RegTextStyle
                        .copyWith(color: ThemeClass.of(context).lightGreyColor),
                    maxLines: 4,
                  ),
                  Gap(10.h),
                 if(definition.date != null) Text(
                    FormatDateHelper.formatWordsNotesDate
                        .format(definition.date!),
                    style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                        color: ThemeClass.of(context).shadePrimaryColor),
                  ),
                ],
              ),
            ),
            Gap(16.w),
            InkWell(
              onTap: ()=> LibraryController().onDeleteWord(definition),
                child: SvgPicture.asset(Assets.imagesDeleteIc))
          ],
        ),
      ),
    );
  }
}
