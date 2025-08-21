import 'package:ELibrary/Utilities/enum.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/core/network/internet_connection_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:state_extended/state_extended.dart';
import '../../../../Widgets/bottom_navbar_widget.dart';
import '../../../Utilities/strings.dart';
import '../../../Utilities/theme_helper.dart';
import '../../../Widgets/empty_widget.dart';
import '../../../Widgets/filter_widget.dart';
import '../../../Widgets/pagination_widget.dart';
import 'Widget/downloads_widget.dart';
import 'Widget/library_widget.dart';
import 'Widget/notes_widget.dart';
import 'Widget/words_widget.dart';
import 'library_controller.dart';

class LibraryScreen extends StatefulWidget {
  static const routeName = "Library";
  const LibraryScreen({super.key});

  @override
  createState() => _LibraryScreenState();
}

class _LibraryScreenState extends StateX<LibraryScreen> {
  _LibraryScreenState() : super(controller: LibraryController()) {
    con = LibraryController();
  }

  late LibraryController con;

  @override
  void initState() {
    if(deviceHaveInternet) con.init();
    if(!deviceHaveInternet) con.onChangeFilter(filterType: LibraryFilterType.downloads);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetConnectionProvider>(
        builder: (context, internetCP,child) {
          if(!internetCP.isConnected && con.selectedFilter != LibraryFilterType.downloads){
            con.selectedFilter = LibraryFilterType.downloads;
            con.getDownloadedBooks();
          }
        return Scaffold(
          appBar: internetCP.isConnected?
          const CustomAppBarWidget.mainScreen(showFilter: false, showNotification: false, showSearch: false,):
          CustomAppBarWidget.detailsScreen(showArrowBack: false,screenName: Strings.downloads.tr,),
          bottomNavigationBar: internetCP.isConnected?
          const BottomNavBarWidget(selected: SelectedBottomNavBar.library):
          IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: ThemeClass.of(context).mainTextColor,width: 3.r),)
              ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom,top: MediaQuery.of(context).padding.bottom/2),
              alignment: Alignment.center,
              child: Text(Strings.noInternetConnection.tr,style: TextStyleHelper.of(context).s18RegTextStyle,),
            ),
          ),
          body: PopScope(
            canPop: internetCP.isConnected,
            child: LoadingScreen(
              loading: con.loading && internetCP.isConnected && con.selectedFilter != LibraryFilterType.downloads,
              onRefresh: ()async=> await con.onChangeFilter(filterType: con.selectedFilter),
              child: Column(
                children: [
                  if(internetCP.isConnected) SizedBox(
                    height: 38.h,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        itemBuilder: (_, index) {
                          if(kIsWeb && LibraryFilterType.values[index] == LibraryFilterType.downloads) return const SizedBox();
                          return GestureDetector(
                            onTap: () =>con.onChangeFilter(filterType:LibraryFilterType.values[index]),
                            child: FilterWidget(
                              title: LibraryFilterType.values[index].name,
                              isSelected:LibraryFilterType.values[index]== con.selectedFilter,
                              height: 38.h,
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Gap(8.w),
                        itemCount:LibraryFilterType.values.length),
                  ),
                  if(!internetCP.isConnected) const SizedBox(width: double.infinity,),
                  Gap(8.h),
                  if(con.selectedFilter == LibraryFilterType.myReads ||
                    con.selectedFilter == LibraryFilterType.bookmarks ||
                    con.selectedFilter == LibraryFilterType.highlights ||
                    con.selectedFilter == LibraryFilterType.wishlist) Expanded(
                      child: Visibility(
                        visible: (con.data.isEmpty&&!con.loading),
                        replacement:PaginationWidget(
                          onLoading:()=> con.onChangeFilter(removeOld: false,filterType: con.selectedFilter),
                          refreshController: con.refreshController,
                          refresh:()=> con.onChangeFilter(filterType: con.selectedFilter),
                          child: ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              itemBuilder: (_, index) => LibraryWidget(
                                book:con.data[index]..inWishlist=true,
                                onSelectMenu: con.onSelectMenu,
                                selectedFilter: con.selectedFilter,
                              ),
                              separatorBuilder: (_, __) => Gap(16.h),
                              itemCount: con.data.length),
                        ),
                        child: const EmptyWidget(),
                      )),
                  if(con.selectedFilter == LibraryFilterType.notes)
                  Expanded(
                      child: Visibility(
                        visible: (con.notesList.isEmpty&&!con.loading),
                        replacement: PaginationWidget(
                          onLoading:()=> con.onChangeFilter(removeOld: false,filterType: con.selectedFilter),
                          refreshController: con.refreshController,
                          refresh:()=> con.onChangeFilter(filterType: con.selectedFilter),
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                            itemBuilder: (_, index) =>NotesWidget(note:con.notesList[index],),
                            separatorBuilder: (_, __) => Gap(16.h),
                            itemCount: con.notesList.length,
                          ),
                        ),
                        child: const EmptyWidget(),
                      ),
                  ),
                  if(con.selectedFilter == LibraryFilterType.words)
                    Expanded(
                        child: Visibility(
                          visible: (con.definitionsList.isEmpty&&!con.loading),
                          replacement: PaginationWidget(
                            onLoading:()=> con.onChangeFilter(removeOld: false,filterType: con.selectedFilter),
                            refreshController: con.refreshController,
                            refresh:()=> con.onChangeFilter(filterType: con.selectedFilter),
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              itemBuilder: (_, index) => WordsWidget(definition:con.definitionsList[index],),
                              separatorBuilder: (_, __) => Gap(16.h),
                              itemCount: con.definitionsList.length,
                            ),
                          ),
                          child: const EmptyWidget(),
                        )),

                  if(!kIsWeb && con.selectedFilter == LibraryFilterType.downloads)
                    Expanded(
                      child: Visibility(
                        visible: (con.downloadedBooks.isEmpty && !con.loading),
                        replacement: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                          itemBuilder: (_, index) => DownloadsWidget(book: con.downloadedBooks[index],),
                          separatorBuilder: (_, __) => Gap(16.h),
                          itemCount: con.downloadedBooks.length,
                        ),
                        child: const EmptyWidget(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
