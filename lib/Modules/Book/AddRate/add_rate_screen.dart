import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/theme_helper.dart';
import '../../../Widgets/custom_appbar_widget.dart';
import '../../../Widgets/custom_button_widget.dart';
import 'Widget/add_rate_book_widget.dart';
import 'add_rate_controller.dart';

class AddRateScreen extends StatefulWidget {
  static const routeName = "AddRate";
  final String bookId;

  const AddRateScreen({super.key, required this.bookId});

  @override
  createState() => _AddRateScreenState();
}

class _AddRateScreenState extends StateX<AddRateScreen>{
  _AddRateScreenState() : super(controller: AddRateController()) {
    con = AddRateController();
  }

  late AddRateController con;

  @override
  void initState() {
    con.getBookDetails(widget.bookId);
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget.detailsScreen(),
      body: LoadingScreen(
        loading: con.loading,
        child: Visibility(
          visible: con.loading,
          replacement: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              ListView(
                controller: con.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                children: [
                  AddRateBookWidget(
                    book: con.book,
                  ),
                  Divider(
                    thickness: 1.r,
                    height: 48.h,
                    color: ThemeClass.of(context).alertBackground,
                  ),
                  Center(child: Column(
                    children: [
                      Text(Strings.rateThisBook.tr,style: TextStyleHelper.of(context).s24SemiBoldTextStyle,),
                      Gap(18.h),
                      RatingBar.builder(
                        direction: Axis.horizontal,
                        minRating: 1,
                        initialRating: con.rate,
                        itemCount: 5,
                        itemSize: 32.r,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                        unratedColor: ThemeClass.of(context).mainTextColor,
                        itemBuilder: (context, index) {
                          if(index < con.rate){
                            return SvgPicture.asset(Assets.imagesSelectedStarIc);
                          }
                          return  SvgPicture.asset(Assets.imagesUnSelectStarIc);
                        },
                        onRatingUpdate: (double value) {
                          setState(() {
                            con.rate = value;
                          });
                        },
                      )
                    ],
                  )),
                  Divider(
                    thickness: 1.r,
                    height: 48.h,
                    color: ThemeClass.of(context).alertBackground,
                  ),
                  Text(Strings.describeOptional.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                  Gap(8.h),
                  CustomTextFieldWidget(
                    focusNode: con.focusNode,
                    underLineBorder:true,
                    maxLine: 7,
                    minLines: 4,
                    style: TextStyleHelper.of(context).s20SemiBoldTextStyle.copyWith(
                      height: 1.5
                    ),
                    controller: con.describeController,
                    insidePadding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 2.w),
                  ),
                  GestureDetector(
                    onTap: (){
                      con.focusNode.requestFocus();
                    },
                    child: Container(
                      color: Colors.transparent,
                      height:140.h,
                      width: 390.w
                      ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(
                    thickness: 1.r,
                    height: 0.h,
                    color: ThemeClass.of(context).alertBackground,
                  ),
                  Gap(24.h),
                  Row(
                    children: [
                      Gap(24.w),
                      Expanded(child: CustomButtonWidget.secondary(
                        onTap:context.pop,
                        title: Strings.cancel.tr,
                      )),
                      Gap(16.w),
                      Expanded(child: CustomButtonWidget.primary(
                        onTap: con.onSubmit,
                        title: Strings.submit.tr,
                      )),
                      Gap(24.w),
                    ],
                  ),
                  Gap(36.h),
                ],
              )
            ],
          ),
          child: const Center(child: SizedBox()),
        ),
      ),
    );
  }
}
