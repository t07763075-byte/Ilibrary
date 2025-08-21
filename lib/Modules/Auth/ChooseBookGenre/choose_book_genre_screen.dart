import 'package:ELibrary/Modules/Auth/ChooseBookGenre/choose_book_genre_controller.dart';
import 'package:ELibrary/Modules/Auth/Widget/cutsom_linear_progress_indicator.dart';
import 'package:ELibrary/Modules/Home/Home/home_screen.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/Widgets/filter_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

class ChooseBookGenreScreen extends StatefulWidget {
  static const String routeName = 'ChooseBookGenreScreen';
  const ChooseBookGenreScreen({super.key});

  @override
  createState() => _ChooseBookGenreScreenState();
}

class _ChooseBookGenreScreenState extends StateX<ChooseBookGenreScreen> {
  _ChooseBookGenreScreenState()
      : super(controller: ChooseBookGenreController()) {
    con = ChooseBookGenreController();
  }

  late ChooseBookGenreController con;

  @override
  void initState() {
    con.getCategoriesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget.detailsScreen(),
      body: LoadingScreen(
        loading: con.loading,
        child: Column(
          children: [
            const CustomLinearProgressIndicator(value: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  children: [
                    Text(
                      Strings.chooseBookGenre.tr,
                      style: TextStyleHelper.of(context).s32SemiBoldTextStyle,
                    ),
                    Gap(12.h),
                    Text(
                      Strings.chooseBookGenreDesc.tr,
                      style: TextStyleHelper.of(context).s18RegTextStyle,
                    ),
                    Gap(32.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 16.h,
                      children: con.categories.map((e) {
                        return GestureDetector(
                          onTap: () {
                            con.toggleBookGenreSelection(e.id);
                          },
                          child: FilterWidget(
                            title: e.name ?? "",
                            isTitleTranslated: true,
                            isSelected: con.selectedCategoriesIds.contains(e.id),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: ThemeClass.of(context).backGroundColor,
                border: Border(
                  top: BorderSide(
                    color: ThemeClass.of(context).alertBackground,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButtonWidget.secondary(
                      title: Strings.skip.tr,
                      onTap: ()=> context.pushNamed(HomeScreen.routeName),
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: CustomButtonWidget.primary(
                      title: Strings.continuee.tr,
                      onTap: con.onConfirm,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
