import 'package:ELibrary/Modules/Home/Filter/filter_provider.dart';
import 'package:ELibrary/Modules/Search/search_data_handler.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:state_extended/state_extended.dart';

import '../../Models/book_model.dart';
import '../../Models/generic_pagination_model.dart';
import '../../Models/search_history_model.dart';
import '../../Utilities/enum.dart';

class SearchController extends StateXController {
  // singleton
  factory SearchController() => _this ??= SearchController._();
  static SearchController? _this;

  SearchController._();

  bool loading = false, isGridView = true, showPreviousSearch = true;
  GenericPaginationModel<SearchHistoryModel> searchHistory =
      GenericPaginationModel<SearchHistoryModel>();
  GenericPaginationModel<BookModel> book = GenericPaginationModel<BookModel>();
  RefreshController gridViewRefreshController = RefreshController(initialRefresh: false);
  RefreshController verticalViewRefreshController = RefreshController(initialRefresh: false);
  RefreshController searchHistoryRefreshController = RefreshController(initialRefresh: false);
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  init(bool showPrevious) {
    showPreviousSearch = showPrevious;
    gridViewRefreshController = RefreshController(initialRefresh: false);
    verticalViewRefreshController = RefreshController(initialRefresh: false);
    searchHistoryRefreshController = RefreshController(initialRefresh: false);
    searchHistory = GenericPaginationModel<SearchHistoryModel>();
    book = GenericPaginationModel<BookModel>();
    if(showPreviousSearch)getSearchHistory();
    if(!showPreviousSearch)getSearchBook(removeOld: true);
  }

  onSearch(String? search) async {
    searchController.text = search??'';

    EasyDebounce.debounce('search', const Duration(milliseconds: 1000),
        () async {
          if(search!=''&&search.toString().trim().length>=1){
            setState(() => loading = true);
            getSearchBook(removeOld: true);
          }else if(search.toString().isEmpty||search.toString().trim()==''){
            showPreviousSearch = true;
            showPreviousSearch = true;
            searchController.clear();
            getSearchHistory();
            setState(() => loading = false);
          }

    });
    setState(() => loading = false);
  }

  getSearchHistory({bool removeOld = false}) async {
    if (removeOld) searchHistory = GenericPaginationModel<SearchHistoryModel>();

    setState(() {
      loading = true;
    });
    final result = await SearchDataHandler.searchHistory(
      oldPagination: searchHistory,
    );
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      final oldItems = searchHistory.data;
      searchHistory = r;
      if (!removeOld) searchHistory.data.insertAll(0, oldItems);
    });
    if (!searchHistory.hasNextPge) {
      searchHistoryRefreshController.loadNoData();
    } else {
      searchHistoryRefreshController.loadComplete();
    }
    searchHistoryRefreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  getSearchBook({bool removeOld = false}) async {
    final filterProvider = Provider.of<FilterProvider>(currentContext_!,listen: false);
    if (removeOld){ book = GenericPaginationModel<BookModel>();
    setState(() {
      loading = true;
    });}
    final result =
        await SearchDataHandler.searchBok(
          oldPagination: book,
            search: searchController.text,
          rating:onRating(filterProvider.selectedRating),
          languageId:filterProvider.language?.id,
          sort:onSort(filterProvider.selectedSort),
        );
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      final oldItems = book.data;
      book = r;
      showPreviousSearch = false;
      if (!removeOld) book.data.insertAll(0, oldItems);
    });
    if (!book.hasNextPge) {
      gridViewRefreshController.loadNoData();
      verticalViewRefreshController.loadNoData();
    } else {
      gridViewRefreshController.loadComplete();
      verticalViewRefreshController.loadComplete();
    }
    gridViewRefreshController.refreshCompleted();
    verticalViewRefreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  deleteSearchHistory(SearchHistoryModel searchHistoryModel) async {

    setState((){loading=true;});
    final result =
        await SearchDataHandler.deleteSearchHistory(id: searchHistoryModel.id);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      searchHistory.data.remove(searchHistoryModel);
    });
    setState((){loading=false;});
  }
  onRating(RatingType? rate){
    switch(rate){
      case RatingType.v5:
        return 5;
      case RatingType.v4_0_plus:
        return 4;
      case RatingType.v3_0_plus:
        return 3;
      case RatingType.v2_0_plus:
        return 2;
      case RatingType.v1_0_plus:
        return 1;
      case null:
      case RatingType.all:
       return null;
    }
  }
  onSort(SortType? sort){
    switch(sort){

      case null:
      return null;
      case SortType.trending:
        return "DownloadCount";
      case SortType.highestRating:
        return "TotalRating";
      case SortType.lowestRating:
        return "TotalRating";
    }
  }
}
