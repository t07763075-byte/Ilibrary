import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Models/generic_pagination_model.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/enum.dart';
import '../../../Utilities/toast_helper.dart';
import 'home_items_data_handler.dart';

class HomeItemsController extends StateXController {
  // singleton
  factory HomeItemsController() => _this ??= HomeItemsController._();
  static HomeItemsController? _this;

  HomeItemsController._();

  bool loading = false, isGridView = true,openSearch=false;
  HomeType? homeType;
  GenericPaginationModel<BookModel> bookPagination =
      GenericPaginationModel<BookModel>();
  RefreshController gridViewRefreshController = RefreshController(initialRefresh: false);
  RefreshController verticalViewRefreshController = RefreshController(initialRefresh: false);
String?searchText;
  init(HomeType? home) {
    searchText='';
    openSearch=false;
    homeType = home;
    bookPagination = GenericPaginationModel<BookModel>();
     gridViewRefreshController = RefreshController(initialRefresh: false);
     verticalViewRefreshController = RefreshController(initialRefresh: false);
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
    if (removeOld){ bookPagination = GenericPaginationModel<BookModel>();

    setState(() {
      loading = true;
    });}
    final result =
        await HomeItemsDataHandler.getData(oldPagination: bookPagination,homeType: homeType,search: searchText);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = bookPagination.data;
      bookPagination = r;
      if (!removeOld) bookPagination.data.insertAll(0, oldItems);
    });
    if (!bookPagination.hasNextPge) {
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
}
