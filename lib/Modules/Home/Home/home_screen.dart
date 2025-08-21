import 'package:ELibrary/Modules/Home/ExploreGenre/ExploreGenre/explore_genre_screen.dart';
import 'package:ELibrary/Utilities/enum.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Widgets/bottom_navbar_widget.dart';
import '../Widget/book_widget.dart';
import '../Widget/explore_widget.dart';
import 'Widget/horizontal_list_widget.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "HomeScreen";

  const HomeScreen({super.key});

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends StateX<HomeScreen> {
  _HomeScreenState() : super(controller: HomeController()) {
    con = HomeController();
  }

  late HomeController con;

  @override
  void initState() {
    con.getHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget.mainScreen(),
      body: LoadingScreen(
        loading: con.loading,
        onRefresh: ()async=> await con.getHome(),
        child: RefreshIndicator(
          onRefresh: ()async=> con.getHome(),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            children: [
              HorizontalListWidget(
                title: Strings.continueReading.tr,
                homeType: HomeType.continueReading,
                itemHeight: 368.h,
                itemsList: con.home.myReads,
                buildWidget: (_) => BookWidget(book: _,),
              ),
              HorizontalListWidget(
                title: Strings.exploreByGenre.tr,
                itemHeight: 80.h,
                routeName: ExploreGenreScreen.routeName,
                itemsList: con.home.categories,
                buildWidget: (_) => ExploreWidget(category: _,),
              ),
              HorizontalListWidget(
                title: Strings.recommendedForYou.tr,
                homeType: HomeType.recommendedForYou,
                itemHeight: 368.h,
                itemsList: con.home.recommended,
                buildWidget: (_) => BookWidget(book: _,),
              ),

              HorizontalListWidget(
                title: Strings.mostRead.tr,
                homeType: HomeType.mostRead,
                itemHeight: 368.h,
                itemsList:con.home.mostRead,
                buildWidget: (_) => BookWidget(book: _,),
              ),
            ],
          ),
        ),
      ), // Main content of HomeScreen
      bottomNavigationBar: const BottomNavBarWidget(selected: SelectedBottomNavBar.home),
    );
  }
}
