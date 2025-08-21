import 'package:ELibrary/Models/category_model.dart';
import 'package:easy_debounce/easy_debounce.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:state_extended/state_extended.dart';
import '../../../../Models/generic_pagination_model.dart';
import '../../../../Utilities/toast_helper.dart';
import 'explore_genre_data_handler.dart';

class ExploreGenreController extends StateXController {
  // singleton
  factory ExploreGenreController() => _this ??= ExploreGenreController._();
  static ExploreGenreController? _this;
  ExploreGenreController._();
  bool loading=false,openSearch=false;
  String?searchText;
  GenericPaginationModel<CategoryModel> explorePagination = GenericPaginationModel<CategoryModel>();
  RefreshController refreshController = RefreshController(initialRefresh: false);

  init() {
    openSearch=false;
    searchText='';
    explorePagination = GenericPaginationModel<CategoryModel>();
    getData(removeOld: true);
  }
  onSearch(String? search) async {

    EasyDebounce.debounce('search', const Duration(milliseconds: 1000),
            () async {
          setState(() => loading = true);
          searchText=search;
          getData(removeOld:true);
        });
    setState(() => loading = false);
  }
  getData({bool removeOld = false}) async {
    if(removeOld){explorePagination = GenericPaginationModel<CategoryModel>();
    setState((){ loading=true;});}
    final result = await ExploreGenreDataHandler.getExplore(oldPagination: explorePagination,searchText: searchText);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = explorePagination.data;
      explorePagination= r;
      if(!removeOld) explorePagination.data.insertAll(0, oldItems);
    });
    if (!explorePagination.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }
}
