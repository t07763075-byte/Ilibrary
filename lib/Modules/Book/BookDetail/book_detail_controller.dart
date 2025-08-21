import 'package:ELibrary/LocalDatabase/book_storage_service.dart';
import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Modules/Book/ReadBook/ReadBookDataHandler/manager_data_handler.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../LocalDatabase/Tables/book_db_table.dart';
import '../../../Utilities/bottom_sheet_helper.dart';
import '../../../Utilities/dialog_helper.dart';
import '../../../Utilities/general_data_handler.dart';
import '../../../Utilities/router_config.dart';
import '../../../Widgets/delete_alert_widget.dart';
import '../../../Widgets/delete_successfully_widget.dart';
import '../AddRate/Widget/submitted_rate_successfully_widget.dart';

class BookDetailController extends StateXController {
  // singleton
  factory BookDetailController() => _this ??= BookDetailController._();
  static BookDetailController? _this;

  BookDetailController._();

  bool loading = false, isDownloadedLocally = false;
  BookModel bookDetails = BookModel();
  String? bookId;
  @override
  void dispose() {
    bookDetails = BookModel();
    super.dispose();
  }

  init(String? id) {
    bookId = id;
    getBookDetails();
    checkDownloadedLocally();
  }

  getBookDetails() async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.getBookDetails(bookId: bookId);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      bookDetails = r;
    });
    setState(() {
      loading = false;
    });
  }

  Future checkDownloadedLocally()async{
    if(kIsWeb) return;
    BookModel? result = await BookDbHelper().getById(id: int.parse(bookId!));
    isDownloadedLocally = result != null;
  }

  Future<void> onDownloadLocallyChange()async{
    int? currentBookId = int.tryParse(bookId??"");
    if(currentBookId == null) return;
    if(!isDownloadedLocally){
      setState(()=> loading = true);
      final result = await GeneralDataHandler.getBookDetails(bookId: currentBookId.toString());
      if(result.isLeft()) return;
      await BookDbHelper().insert(book: result.getOrElse(()=> BookModel()));
      await BookStorageService.saveBook(bookId: currentBookId);
      ReadBookDataHandlerManage(isSavedLocal: true).getHighlightsList(bookId: currentBookId);
      ReadBookDataHandlerManage(isSavedLocal: true).getNotesList(bookId: currentBookId);
      isDownloadedLocally = true;
      setState(()=> loading = false);
    }
  }


  addAndRemoveFromWishlist() {
    if (bookDetails.inWishlist) deleteFromWishlist();
    if (!bookDetails.inWishlist) addToWishlist();
  }

  addToWishlist() async {
    setState(() {
      loading = true;
    });
    final result =
        await GeneralDataHandler.addToWishlist(bookId: bookDetails.id);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      bookDetails.inWishlist = true;
    });
    setState(() {
      loading = false;
    });
  }

  deleteFromWishlist() async {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () => deleteFromWishlistAPI(),
          message: Strings.deleteBookFromWishList.tr,
        ));
  }

  deleteFromWishlistAPI() async {
    setState(() {
      loading = true;
    });
    final result =
        await GeneralDataHandler.deleteFromWishlist(bookId: bookDetails.id);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      bookDetails.inWishlist = false;
      deleteSuccessfully();
    });
    setState(() {
      loading = false;
    });
  }
  deleteSuccessfully() {
    DialogHelper.custom(context: currentContext_!)
        .customDialog(dialogWidget:  DeleteSuccessfullyWidget(
      message: Strings.deletedSuccessfullyDes.tr,
    ));
  }
  onAddRate() async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.addRating(
        rating: bookDetails.myRate, bookId: bookDetails.id);
    result.fold((l) {
      ToastHelper.showSuccess(message: l.message);
    }, (r) async {
      // bookDetails.totalRating=r.totalRating;
      // bookDetails.totalRatingCount=r.totalRatingCount??0;
      getBookDetails();
      DialogHelper.custom(context: currentContext_!)
          .customDialog(dialogWidget:  SubmittedRateSuccessfullyWidget(
          bookTitle:bookDetails.title,
        onClose: currentContext_!.pop,
      ),);
    });
    setState(() {
      loading = false;
    });
  }
}
