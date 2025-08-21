import 'package:ELibrary/Modules/Book/Widget/book_ratings_reviews_widget.dart';
import 'package:ELibrary/Modules/Book/ReadBook/read_book_screen.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/Widgets/custom_network_image.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Utilities/theme_helper.dart';
import '../../../generated/assets.dart';
import '../AboutBook/about_book_screen.dart';
import '../AddRate/add_rate_screen.dart';
import '../RateScreen/rate_screen.dart';
import 'book_detail_controller.dart';

class BookDetailScreen extends StatefulWidget {
  static const routeName = "BookDetailScreen";
  final String? bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends StateX<BookDetailScreen> {
  _BookDetailScreenState() : super(controller: BookDetailController()) {
    con = BookDetailController();
  }

  late BookDetailController con;

  @override
  void initState() {
    con.init(widget.bookId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget.mainDetailsScreen(
          onFavorite: con.addAndRemoveFromWishlist,
          isFavorite: con.bookDetails.inWishlist,
        ),
        body: LoadingScreen(
          loading: con.loading,
          onRefresh: () async => con.getBookDetails(),
          child: Visibility(
            visible: con.bookDetails.id != null,
            replacement: const Center(child: SizedBox()),
            child: RefreshIndicator(
              onRefresh: () async => con.getBookDetails(),
              child: ListView(
                padding: EdgeInsets.all(20.r),
                children: [
                  SizedBox(
                    height: 230.h,
                    child: Row(
                      children: [
                        CustomNetworkImage(
                            url: con.bookDetails.imageUrl,
                            width: 150.w,
                            height: 230.h),
                        Gap(16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200.w,
                                child: Text(
                                  con.bookDetails.title ?? '',
                                  style: TextStyleHelper.of(context)
                                      .s24SemiBoldTextStyle
                                      .copyWith(height: 1.5),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Gap(12.h),
                              Text(
                                con.bookDetails.bookAuthors.firstOrNull?.name ??
                                    '',
                                style: TextStyleHelper.of(context)
                                    .s14RegTextStyle
                                    .copyWith(
                                        color: ThemeClass.of(context)
                                            .primaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(12.h),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: con.bookDetails.bookCategories
                                        .map((item) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 6.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                              color: ThemeClass.of(context)
                                                  .alertBackground,
                                            ),
                                            child: Text(
                                              item.nameAfterSplit ?? '',
                                              style: TextStyleHelper.of(context)
                                                  .s12RegTextStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(24.h),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  con.bookDetails.totalRating.toString(),
                                  style: TextStyleHelper.of(context)
                                      .s24SemiBoldTextStyle,
                                ),
                                Gap(6.w),
                                RatingBarIndicator(
                                  rating: (con.bookDetails.totalRating / 5),
                                  direction: Axis.horizontal,
                                  itemCount: 1,
                                  itemSize: 18.r,
                                  unratedColor:
                                      ThemeClass.of(context).darkGreyColor,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: ThemeClass.of(context).mainTextColor,
                                  ),
                                ),
                              ],
                            ),
                            Gap(4.h),
                            Text(
                              "${con.bookDetails.totalReviews ?? 0} ${Strings.reviews.tr}",
                              style:
                                  TextStyleHelper.of(context).s12RegTextStyle,
                            )
                          ],
                        ),
                        VerticalDivider(
                          thickness: 1.r,
                          endIndent: 4.h,
                          indent: 4.h,
                          color: ThemeClass.of(context).alertBackground,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  con.bookDetails.pageCount ?? '0',
                                  style: TextStyleHelper.of(context)
                                      .s24SemiBoldTextStyle,
                                ),
                              ],
                            ),
                            Gap(4.h),
                            Text(
                              Strings.pages.tr,
                              style:
                                  TextStyleHelper.of(context).s12RegTextStyle,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Gap(24.h),
                  Row(
                    children: [
                      if(!kIsWeb && !con.isDownloadedLocally) CustomButtonWidget.outline(
                        width: 80.w,
                        height: 60.h,
                        radius: 16.r,
                        onTap: con.onDownloadLocallyChange,
                        child: Center(child: SvgPicture.asset(Assets.imagesDownload,
                          colorFilter: ColorFilter.mode(ThemeClass.of(context).primaryColor, BlendMode.srcIn),)),
                      ),
                      if(!con.isDownloadedLocally) Gap(12.w),
                      Expanded(
                        child: CustomButtonWidget.primary(
                          title: Strings.readBook.tr,
                          radius: 16.r,
                          onTap: () {
                            context
                                .pushNamed(ReadBookScreen.routeName, pathParameters: {
                              "bookId": con.bookDetails.id.toString(),
                              "bookName": con.bookDetails.title.toString(),
                            });
                            // _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(24.h),
                  if(con.bookDetails.bookSubjects.isNotEmpty)...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Strings.aboutThisEbook.tr,
                          style: TextStyleHelper.of(context).s24SemiBoldTextStyle,
                        ),
                        GestureDetector(
                          onTap: () => context.pushNamed(
                              AboutBookScreen.routeName,
                              queryParameters: {'bookId': con.bookId.toString()}),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: ThemeClass.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                    Gap(12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: con.bookDetails.bookSubjects
                          .map(
                            (e) => Text(
                          e.name.toString(),
                          style: TextStyleHelper.of(context)
                              .s18SemiBoldTextStyle,
                        ),
                      ).toList(),
                    ),
                    Gap(24.h),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.ratingsAndReviews.tr,
                        style: TextStyleHelper.of(context).s24SemiBoldTextStyle,
                      ),
                      GestureDetector(
                        onTap: () => context.pushNamed(RateScreen.routeName, queryParameters: {'bookId': con.bookId.toString(),}).then(
                              (value) => con.getBookDetails(),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: ThemeClass.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  BookRatingsReviewsWidget(
                    bookData: con.bookDetails,
                  ),
                  Divider(
                    color: ThemeClass.of(context).alertBackground,
                    height: 32.h,
                    thickness: 1.h,
                  ),
                  Center(
                      child: Column(
                    children: [
                      Text(
                        Strings.rateThisBook.tr,
                        style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                      ),
                      Gap(16.h),
                      RatingBar.builder(
                        direction: Axis.horizontal,
                        minRating: 1,
                        initialRating: con.bookDetails.myRate,
                        itemCount: 5,
                        itemSize: 32.r,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                        unratedColor: ThemeClass.of(context).mainTextColor,
                        itemBuilder: (context, index) {
                          if (index < con.bookDetails.myRate) {
                            return SvgPicture.asset(
                                Assets.imagesSelectedStarIc);
                          }
                          return SvgPicture.asset(Assets.imagesUnSelectStarIc);
                        },
                        onRatingUpdate: (double value) async {
                          setState(() {
                            con.bookDetails.myRate = value;
                          });
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          if (con.bookDetails.myRate == value) con.onAddRate();
                        },
                      ),
                      Gap(16.h),
                      CustomButtonWidget.outline(
                        onTap: () {
                          context.pushNamed(AddRateScreen.routeName,
                              queryParameters: {
                                'bookId': con.bookId.toString(),
                              })
                              .then((e) {
                            con.getBookDetails();
                          });
                        },
                        width: 173.w,
                        height: 45.h,
                        child: Text(
                          Strings.writeReview.tr,
                          style: TextStyleHelper.of(context)
                              .s18SemiBoldTextStyle
                              .copyWith(
                                  color: ThemeClass.of(context).primaryColor),
                        ),
                      ),
                      Gap(16.h),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ) // Main content of HomeScreen
        );
  }
}
