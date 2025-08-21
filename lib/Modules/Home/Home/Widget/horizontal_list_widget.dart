import 'dart:convert';
import 'package:ELibrary/Utilities/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../HomeItems/home_items_screen.dart';

class HorizontalListWidget<T> extends StatelessWidget {
  final String title;
  final String? routeName;
  final HomeType? homeType;
  final double itemHeight;
  final double? separateValue;
  final List<T> itemsList;
  final Widget Function(T) buildWidget;


  const HorizontalListWidget(
      {super.key,
        required this.title,
        required this.itemHeight,
        required this.buildWidget,
        this.separateValue,
        this.homeType,
        required this.itemsList,  this.routeName,
      });

  @override
  Widget build(BuildContext context) {
    if (itemsList.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(28.h),
        if(title.isNotEmpty) InkWell(
          onTap: ()=>context.pushNamed(routeName??HomeItemsScreen.routeName,
              queryParameters: {
                'homeType':base64Url.encode(utf8.encode(homeType.toString())) ,
              }),
          child: Row(
            children: [
              Text(title,style: TextStyleHelper.of(context).s24SemiBoldTextStyle,),
              const Spacer(),
              Icon(Icons.arrow_forward,color: ThemeClass.of(context).primaryColor,)
            ],
          ),
        ),
        if(title.isNotEmpty)Gap(20.h),
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            itemCount: itemsList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => buildWidget(itemsList[index]),
            separatorBuilder: (_, i) => Gap(separateValue??16.w),
          ),
        ),
      ],
    );
  }
}