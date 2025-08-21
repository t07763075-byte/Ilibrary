import 'package:ELibrary/Modules/Book/AddRate/add_rate_screen.dart';
import 'package:ELibrary/Modules/Book/RateScreen/rate_controller.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/enum.dart';
import '../../../Utilities/text_style_helper.dart';
import '../../../Utilities/theme_helper.dart';
import '../../../Widgets/custom_appbar_widget.dart';
import '../../../Widgets/pagination_widget.dart';
import '../Widget/book_ratings_reviews_widget.dart';
import 'Widget/comment_widget.dart';

class RateScreen extends StatefulWidget {
  static const routeName = "RateScreen";
  final String bookId;

  const RateScreen({super.key, required this.bookId});

  @override
  createState() => _RateScreenState();
}

class _RateScreenState extends StateX<RateScreen> {
  _RateScreenState() : super(controller: RateController()) {
    con = RateController();
  }

  late RateController con;

  @override
  void initState() {

    con.init(widget.bookId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.mainDetailsScreen(
        screenName: Strings.ratingsAndReviews.tr,
        showFavorite: false,
        showShare: false,
        onAddRate: () => context.pushNamed(AddRateScreen.routeName,   queryParameters: {
          'bookId': con.bookId.toString(),
        }),
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: PaginationWidget(
          onLoading: con.getData,
          refreshController: con.refreshController,
          refresh: () => con.getData(removeOld: true),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              BookRatingsReviewsWidget(bookData: con.book),
              Gap(16.h),
              Divider(
                color: ThemeClass.of(context).alertBackground,
                height: 0,
              ),
              Gap(24.h),
              SizedBox(
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: RatingFilterType.values.length,
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        con.selectedRating = RatingFilterType.values[index];
                      });
                      con.getData(removeOld: true);
                    },
                    child: RatingFilterWidget(
                      ratingFilterType: RatingFilterType.values[index],
                      isSelect:
                          RatingFilterType.values[index] == con.selectedRating,
                    ),
                  ),
                  separatorBuilder: (_, __) => Gap(12.w),
                ),
              ),
              Gap(24.h),
              Divider(
                color: ThemeClass.of(context).alertBackground,
                height: 0,
              ),
              Gap(24.h),
              ...con.ratingPagination.data.map((rating) {
                return CommentWidget(
                  rating: rating,
                  ratingAction:(action)=> con.ratingAction(type: action,rating: rating),
                  onFavPress: () async {
                    con.likeAndUnLike(ratingId: rating.ratingId);
                    rating.isUserLike = !rating.isUserLike;
                    if (rating.isUserLike) {
                      rating.likes++;
                    } else {
                      rating.likes--;
                    }
                    setState(() {});
                  },

                );
              }).toList(),
            ],
          ),
        ),
      ), // Main content of HomeScreen
    );
  }
}

class RatingFilterWidget extends StatelessWidget {
  final RatingFilterType ratingFilterType;
  final bool isSelect;

  const RatingFilterWidget(
      {super.key, required this.ratingFilterType, required this.isSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 83.w,
        height: 38.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelect
              ? ThemeClass.of(context).primaryColor
              : Colors.transparent,
          border: Border.all(color: ThemeClass.of(context).primaryColor),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              size: 16.sp,
              color: isSelect
                  ? ThemeClass.of(context).mainTextColor
                  : ThemeClass.of(context).primaryColor,
            ),
            Gap(6.w),
            Text(
              ratingFilterType.index == 0
                  ? Strings.all.tr
                  : ratingFilterType.index.toString(),
              style: TextStyleHelper.of(context).s16RegTextStyle,
            ),
          ],
        ));
  }
}
