import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/empty_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:state_extended/state_extended.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Widgets/custom_textfield_widget.dart';
import '../../../../Widgets/pagination_widget.dart';
import '../../../../generated/assets.dart';
import '../../Widget/explore_widget.dart';
import 'explore_genre_controller.dart';

class ExploreGenreScreen extends StatefulWidget {
  static const routeName = "ExploreGenre";

  const ExploreGenreScreen({super.key});

  @override
  createState() => _ExploreGenreScreenState();
}

class _ExploreGenreScreenState extends StateX<ExploreGenreScreen> {
  _ExploreGenreScreenState() : super(controller: ExploreGenreController()) {
    con = ExploreGenreController();
  }

  late ExploreGenreController con;
@override
  void initState() {
    con.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: Strings.exploreByGenre.tr,
        showSearch: true,
        onSearch: ()=>setState((){
          con.openSearch=!con.openSearch;
        }),
      ),
      body: LoadingScreen(
        loading: con.loading,
        onRefresh: ()async=> await con.getData(),
        child: Column(
          children: [
            if(con.openSearch) Padding(
              padding:  EdgeInsets.only(bottom: 16.h,left: 24.w,right: 24.w),
              child: CustomTextFieldWidget(
                backGroundColor: ThemeClass.of(context).cartColor,
                borderColor: ThemeClass.of(context).cartColor,
                insidePadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
                style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
                isDense: true,

                prefixIcon: Padding(
                  padding:  EdgeInsetsDirectional.only(start: 12.w,end: 12.w),
                  child: SvgPicture.asset(Assets.imagesSearchIc,height: 20.r,),
                ),
                onchange: con.onSearch,
              ),
            ),
            Expanded(
              child: Visibility(
                visible:(con.explorePagination.data.isEmpty&&!con.loading) ,
                replacement: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine the number of columns dynamically based on screen width
                    int crossAxisCount = (constraints.maxWidth ~/ 200).clamp(2, 6); // Adjust columns dynamically (min 2, max 6)
                    double spacing = 12.r;
                    // Calculate item dimensions
                    double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
                    double itemHeight = itemWidth * 92 / 185; // Maintain aspect ratio

                    return PaginationWidget(
                      onLoading: con.getData,
                      refreshController: con.refreshController,
                      refresh: ()=>con.getData(removeOld: true),
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio: itemWidth / itemHeight, // Use calculated aspect ratio
                        ),
                        itemCount: con.explorePagination.data.length,
                        itemBuilder: (_, index) => ExploreWidget(
                          height: itemHeight,
                          width: itemWidth,
                          category: con.explorePagination.data[index],
                        ),
                      ),
                    );
                  },
                ),
                child: const EmptyWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
