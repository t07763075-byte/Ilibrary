import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import '../../Utilities/strings.dart';
import '../../Utilities/text_style_helper.dart';
import '../../Utilities/theme_helper.dart';
import '../../Widgets/empty_widget.dart';
import '../../Widgets/pagination_widget.dart';
import '../../Widgets/showin_widget.dart';
import '../Home/Widget/book_widget.dart';
import '../../Widgets/vertical_home_item_widget.dart';
import './search_controller.dart' as search;
import 'Widget/search_appbar_widget.dart';
import 'Widget/serach_filter_widget.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "Search";
  final bool showPreviousSearch;

  const SearchScreen({super.key, required this.showPreviousSearch});

  @override
  createState() => _SearchScreenState();
}

class _SearchScreenState extends StateX<SearchScreen> {
  _SearchScreenState() : super(controller: search.SearchController()) {
    con = search.SearchController();
  }

  late search.SearchController con;

  @override
  void initState() {
    super.initState();
    con.init(widget.showPreviousSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppbarWidget(
        onSearch: con.onSearch,
        searchController: con.searchController,
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: Visibility(
          visible: con.showPreviousSearch,
          replacement: Column(
            children: [
              Column(
                children: [
                  const SearchFilterWidget(),
                  Gap(16.h),
                  ShowInWidget(
                    isGridView: con.isGridView,
                    onGridView: () => setState(() {
                      con.isGridView = true;
                    }),
                    onListScrollIc: () => setState(() {
                      con.isGridView = false;
                    }),
                  ),
                ],
              ),
              Gap(8.h),
              if (con.isGridView)
                Expanded(
                  child: Visibility(
                    visible: (con.book.data.isEmpty && !con.loading),
                    replacement: LayoutBuilder(builder: (context, constraints) {
                      int crossAxisCount =
                          (constraints.maxWidth ~/ 200).clamp(2, 6);
                      double itemWidth =
                          (constraints.maxWidth - (crossAxisCount - 1) * 12.w) /
                              crossAxisCount;
                      double itemHeight = itemWidth * 364 / 186;

                      return PaginationWidget(
                        onLoading: con.getSearchBook,
                        refreshController: con.gridViewRefreshController,
                        refresh: () => con.getSearchBook(removeOld: true),
                        child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 16.h),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 12.w,
                                    mainAxisSpacing: 24.h,
                                    childAspectRatio: (itemWidth / itemHeight)),
                            itemCount: con.book.data.length,
                            // Number of items in the grid
                            itemBuilder: (_, index) => BookWidget(
                                  book: con.book.data[index],
                                  width: itemWidth,
                                  height: itemHeight,
                                )),
                      );
                    }),
                    child: const EmptyWidget(),
                  ),
                ),
              if (!con.isGridView)
                Expanded(
                    child: Visibility(
                  visible: (con.book.data.isEmpty && !con.loading),
                  replacement: PaginationWidget(
                    onLoading: con.getSearchBook,
                    refreshController: con.verticalViewRefreshController,
                    refresh: () => con.getSearchBook(removeOld: true),
                    child: ListView.separated(

                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        itemBuilder: (_, index) =>
                            VerticalHomeItemWidget(book: con.book.data[index]),
                        separatorBuilder: (_, __) => Gap(24.h),
                        itemCount: con.book.data.length),
                  ),
                  child: const EmptyWidget(),
                ))
            ],
          ),
          child: Column(
            children: [
              Gap(16.h),
              Row(
                children: [
                  Gap(24.w),
                  Expanded(
                      child: Text(
                    Strings.previousSearch.tr,
                    style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                  )),
                  Icon(
                    Icons.clear,
                    size: 20.r,
                    color: ThemeClass.of(context).mainTextColor,
                  ),
                  Gap(24.w),
                ],
              ),
              Gap(24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Divider(
                  height: 0,
                  thickness: 1.h,
                  color: ThemeClass.of(context).alertBackground,
                ),
              ),
              Gap(12.h),
              Expanded(
                  child: PaginationWidget(
                onLoading: con.getSearchHistory,
                refreshController: con.searchHistoryRefreshController,
                refresh: () => con.getSearchHistory(removeOld: true),
                child: ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          con.onSearch(
                              con.searchHistory.data[index].searchKeyword);
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              con.searchHistory.data[index].searchKeyword ?? '',
                              style: TextStyleHelper.of(context)
                                  .s20SemiBoldTextStyle,
                            )),
                            InkWell(
                              onTap: () => con.deleteSearchHistory(
                                  con.searchHistory.data[index]),
                              child: Icon(
                                Icons.clear,
                                size: 20.r,
                                color: ThemeClass.of(context).mainTextColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => Gap(24.h),
                    itemCount: con.searchHistory.data.length),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
