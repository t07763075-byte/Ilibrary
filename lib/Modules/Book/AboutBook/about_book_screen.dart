import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/theme_helper.dart';
import 'about_book_controller.dart';

class AboutBookScreen extends StatefulWidget {
  static const routeName="AboutBookScreen";
  final String bookId;

  const AboutBookScreen({super.key, required this.bookId});

  @override
  createState() => _AboutBookScreenState();
}

class _AboutBookScreenState extends StateX<AboutBookScreen> {
  _AboutBookScreenState():super(controller:AboutBookController()){
    con=AboutBookController();
  }
  late AboutBookController con;
@override
  void initState() {
  con.getBookDetails(widget.bookId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBarWidget.mainDetailsScreen(
        screenName: Strings.aboutThisEbook.tr,
        showFavorite: false,
        showShare: false,
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: Visibility(
          visible: con.loading,
          replacement: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
            children: [
              Text(
                Strings.bookTitle.tr,
                style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
              ),
              Gap(4.h),
              Text(
                con.book.title??'',
                style: TextStyleHelper.of(context)
                    .s24RegTextStyle.copyWith(
                    color: ThemeClass.of(context).primaryColor
                ),
              ),
              Gap(24.h),
              Divider(color: ThemeClass.of(context).alertBackground,thickness: 1.h,height: 0,),
              Gap(24.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: con.book.bookSubjects.map((e)=>   Text(
                  e.name.toString(),
                  style: TextStyleHelper.of(context).s18RegTextStyle,
                ),).toList(),
              ),
              Gap(24.h),
              Divider(color: ThemeClass.of(context).alertBackground,thickness: 1.h,height: 0,),
              Gap(24.h),
              Text(
                Strings.language.tr,
                style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
              ),
              Gap(4.h),
              Wrap(
                children: con.book.bookLanguages.map((e)=>   Text(
                  e.code.toString(),
                  style: TextStyleHelper.of(context)
                      .s18RegTextStyle,
                ),).toList(),
              ),

              Gap(24.h),
              Text(
                Strings.author.tr,
                style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
              ),
              Gap(4.h),
              Wrap(
                children: con.book.bookAuthors.map((e)=>   Text(
                  e.name.toString(),
                  style: TextStyleHelper.of(context).s18RegTextStyle.copyWith(
                      color: ThemeClass.of(context).primaryColor
                  ),
                ),).toList(),
              ),

              Gap(24.h),
              Text(
                Strings.pages.tr,
                style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
              ),
              Gap(4.h),
              Text(
                con.book.pageCount??'',
                style: TextStyleHelper.of(context)
                    .s18RegTextStyle,
              ),
              Gap(24.h),
              Text(
                Strings.genre.tr,
                style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
              ),
              Gap(4.h),
              Wrap(
                runSpacing: 8.h,
                spacing: 8.w,
                children: con.book.bookCategories.map((e)=>   Text(
                  e.name.toString(),
                  style: TextStyleHelper.of(context).s18RegTextStyle.copyWith(
                      color: ThemeClass.of(context).primaryColor
                  ),
                ),).toList(),
              ),
            ],
          ),
          child: const Center(child: SizedBox.shrink()),
        ),
      ), // Main content of HomeScreen
    );
  }

}
