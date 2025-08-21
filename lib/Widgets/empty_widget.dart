import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class EmptyWidget extends StatelessWidget {
  final String? emptyText;
  const EmptyWidget({super.key, this.emptyText});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.imagesNoBookIc),
        Text(emptyText ?? Strings.noBooksFound.tr,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,)
      ],
    );
  }
}
