import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Modules/Book/AddRate/add_rate_screen.dart';
import 'package:ELibrary/Modules/Book/RateScreen/rate_detail_handler.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Models/generic_pagination_model.dart';
import '../../../Models/rating_data_model.dart';
import '../../../Utilities/enum.dart';
import '../../../Utilities/toast_helper.dart';

class RateController extends StateXController {
  // singleton
  factory RateController() => _this ??= RateController._();
  static RateController? _this;

  RateController._();

  bool loading = false, isFav = false;
String?bookId;
  BookModel book=BookModel();

  GenericPaginationModel<RatingDataModel> ratingPagination =
      GenericPaginationModel<RatingDataModel>();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RatingFilterType selectedRating = RatingFilterType.all;

  init(String?id) {
    bookId=id;
    selectedRating = RatingFilterType.all;
    ratingPagination = GenericPaginationModel<RatingDataModel>();
    getData();
  }

  ratingAction(
      {required RatingActionType type, required RatingDataModel rating}) {
    switch (type) {
      case RatingActionType.edit:
        currentContext_!.pushNamed(AddRateScreen.routeName,queryParameters: {
          'bookId': bookId.toString(),
        });
        break;
      case RatingActionType.delete:
        deleteRating(rating: rating);
        break;
    }
  }

  getData({bool removeOld = false}) async {
    if (removeOld) ratingPagination = GenericPaginationModel<RatingDataModel>();

    setState(() {
      loading = true;
    });
    final result = await RateDetailHandler.getData(
        oldPagination: ratingPagination,
        bookId: bookId??'',
        rate: selectedRating.index);
    result.fold((l) {
       // ToastHelper.showError(message: l.message);
    }, (r) {
      book.totalRating = r.totalRating??0;
      book.totalRatingCount = r.totalRatingCount ?? 0;
      book.rating1Count = r.rating1Count??0;
      book.rating2Count = r.rating2Count??0;
      book.rating3Count = r.rating3Count??0;
      book.rating4Count = r.rating4Count??0;
      book.rating5Count = r.rating5Count??0;
      final oldItems = ratingPagination.data;
      ratingPagination = r.listRatings!;

      if (!removeOld) ratingPagination.data.insertAll(0, oldItems);
    });
    if (!ratingPagination.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  likeAndUnLike({int? ratingId}) async {
    setState(() {
      loading = true;
    });
    final result = await RateDetailHandler.likeAndUnLike(ratingId: ratingId);
    result.fold((l) {
      ToastHelper.showSuccess(message: l.message);
    }, (r) {});
    setState(() {
      loading = false;
    });
  }

  deleteRating({RatingDataModel? rating}) async {
    setState(() {
      loading = true;
    });
    final result =
        await RateDetailHandler.deleteRating(ratingId: rating?.ratingId);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      book.totalRating = r.totalRating??0;
      book.totalRatingCount = r.totalRatingCount ?? 0;
      book.rating1Count = r.rating1Count??0;
      book.rating2Count = r.rating2Count??0;
      book.rating3Count = r.rating3Count??0;
      book.rating4Count = r.rating4Count??0;
      book.rating5Count = r.rating5Count??0;
      ratingPagination.data.remove(rating);
    });
    setState(() {
      loading = false;
    });
  }
}
