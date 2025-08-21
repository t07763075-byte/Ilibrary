import 'package:ELibrary/Widgets/vertical_home_item_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/enum.dart';
import '../../../Widgets/custom_appbar_widget.dart';
import '../../../Widgets/empty_widget.dart';
import '../../../Widgets/pagination_widget.dart';
import '../../../Widgets/showin_widget.dart';
import '../Widget/book_widget.dart';
import 'home_items_controller.dart';

class HomeItemsScreen extends StatefulWidget {
  static const routeName = "HomeItems";
  final HomeType homeType;

  const HomeItemsScreen({super.key, required this.homeType});

  @override
  createState() => _HomeItemsScreenState();
}

class _HomeItemsScreenState extends StateX<HomeItemsScreen> {
  _HomeItemsScreenState() : super(controller: HomeItemsController()) {
    con = HomeItemsController();
  }

  late HomeItemsController con;

  @override
  void initState() {
    con.init(widget.homeType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(
        screenName: con.homeType?.name.tr,
        showSearch: true,
        showFilter: true,
        onSearch: () => setState(() {
          con.openSearch = !con.openSearch;
        }),
      ),
      body: LoadingScreen(
        loading: con.loading,
        child: Column(
          children: [
            Gap(16.h),
            ShowInWidget(
              onchange: con.onSearch,
              openSearch: con.openSearch,
              isGridView: con.isGridView,
              onGridView: () => setState(() {
                con.isGridView = true;
              }),
              onListScrollIc: () => setState(() {
                con.isGridView = false;
              }),
            ),
            if (con.isGridView)
              Expanded(
                child: Visibility(
                  visible: (con.bookPagination.data.isEmpty && !con.loading),
                  replacement: LayoutBuilder(
                      builder: (context, constraints) {

                        int crossAxisCount = (constraints.maxWidth ~/ 200).clamp(2, 6);
                        double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 12.w) / crossAxisCount;
                        double itemHeight = itemWidth * 364 / 186;
                      return PaginationWidget(
                        onLoading: con.getData,
                        refreshController: con.gridViewRefreshController,
                        refresh: () => con.getData(removeOld: true),
                        child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 16.h),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 24.h,
                                childAspectRatio: (itemWidth / itemHeight)),
                            itemCount: con.bookPagination.data.length,
                            // Number of items in the grid
                            itemBuilder: (_, index) => BookWidget(
                                  book: con.bookPagination.data[index],
                              width: itemWidth,
                              height:itemHeight ,
                                )),
                      );
                    }
                  ),
                  child: const EmptyWidget(),
                ),
              ),
            if (!con.isGridView)
              Expanded(
                  child: Visibility(
                visible: (con.bookPagination.data.isEmpty && !con.loading),
                replacement: PaginationWidget(
                  onLoading: con.getData,
                  refreshController: con.verticalViewRefreshController,
                  refresh: () => con.getData(removeOld: true),
                  child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 16.h),
                      itemBuilder: (_, index) => VerticalHomeItemWidget(
                            book: con.bookPagination.data[index],
                          ),
                      separatorBuilder: (_, __) => Gap(24.h),
                      itemCount: con.bookPagination.data.length),
                ),
                child: const EmptyWidget(),
              ))
          ],
        ),
      ),
    );
  }
}
