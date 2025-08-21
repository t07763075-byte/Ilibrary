import 'package:ELibrary/Models/category_model.dart';
import 'package:ELibrary/Utilities/router_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../Utilities/text_style_helper.dart';
import '../../../Widgets/custom_network_image.dart';
import '../ExploreGenre/BookByGenre/book_by_genre_screen.dart';

class ExploreWidget extends StatelessWidget {
  final double? width, height;
  final CategoryModel category;

  const ExploreWidget(
      {super.key, this.width, this.height, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> context.pushNamed(BookByGenreScreen.routeName, queryParameters: RouterHelper.encode(category.toJson()),),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          CustomNetworkImage(
            url: category.image,
            width: width ?? 160.w,
            height: height ?? 80.h,

          ),
          PositionedDirectional(
              bottom: 8.h,
              start: 12.w,
              end: 4.w,
              child: Text(
                category.name ?? '',
                style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
                  height: 1.2.h
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }
}
