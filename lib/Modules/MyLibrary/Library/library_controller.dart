import 'package:ELibrary/LocalDatabase/Tables/book_db_table.dart';
import 'package:ELibrary/Models/definition_model.dart';
import 'package:ELibrary/Modules/Account/About/about_screen.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:state_extended/state_extended.dart';
import '../../../LocalDatabase/book_storage_service.dart';
import '../../../LocalDatabase/Tables/highlight_db_table.dart';
import '../../../LocalDatabase/Tables/note_db_table.dart';
import '../../../Models/book_model.dart';
import '../../../Models/book_note_model.dart';
import '../../../Models/generic_pagination_model.dart';
import '../../../Utilities/bottom_sheet_helper.dart';
import '../../../Utilities/dialog_helper.dart';
import '../../../Utilities/elegant_notification.dart';
import '../../../Utilities/enum.dart';
import '../../../Utilities/general_data_handler.dart';
import '../../../Utilities/strings.dart';
import '../../../Utilities/toast_helper.dart';
import '../../../Widgets/delete_alert_widget.dart';
import '../../../Widgets/delete_successfully_widget.dart';
import 'library_data_handler.dart';

class LibraryController extends StateXController {
  // singleton
  factory LibraryController() => _this ??= LibraryController._();
  static LibraryController? _this;

  LibraryController._();

  LibraryFilterType selectedFilter = LibraryFilterType.myReads;
  bool loading = false;

  RefreshController refreshController = RefreshController(initialRefresh: false);

  GenericPaginationModel<BookModel> myReads = GenericPaginationModel<BookModel>();
  GenericPaginationModel<BookModel> bookMarks = GenericPaginationModel<BookModel>();
  GenericPaginationModel<BookModel> wishList = GenericPaginationModel<BookModel>();
  GenericPaginationModel<BookModel> highlights = GenericPaginationModel<BookModel>();
  GenericPaginationModel<BookNoteModel> notes = GenericPaginationModel<BookNoteModel>();
  GenericPaginationModel<DefinitionModel> words = GenericPaginationModel<DefinitionModel>();
  List<BookModel> data = [];
  List<BookNoteModel> notesList = [];
  List<DefinitionModel> definitionsList = [];
  List<BookModel> downloadedBooks = [];

  @override
  void dispose() {
    data.clear();
    super.dispose();
  }

  init() {
    selectedFilter = LibraryFilterType.myReads;
    myReads = GenericPaginationModel<BookModel>();
    wishList = GenericPaginationModel<BookModel>();
    highlights = GenericPaginationModel<BookModel>();
    bookMarks = GenericPaginationModel<BookModel>();
    notes = GenericPaginationModel<BookNoteModel>();
    words = GenericPaginationModel<DefinitionModel>();
    onChangeFilter(filterType: selectedFilter);
  }

  onChangeFilter(
      {required LibraryFilterType filterType, bool removeOld = true}) async{
    if (removeOld) {
      data.clear();
      notesList.clear();
      definitionsList.clear();
    }
    setState(() {
      selectedFilter = filterType;
    });
    switch (filterType) {
      case LibraryFilterType.myReads:
        await getMyReads(removeOld: removeOld);
        break;
      case LibraryFilterType.bookmarks:
        await getBookMarks(removeOld: removeOld);
        break;
      case LibraryFilterType.wishlist:
        await getWishlist(removeOld: removeOld);
        break;
      case LibraryFilterType.highlights:
        await getHighlights(removeOld: removeOld);
        break;
      case LibraryFilterType.notes:
        await getUserNotes(removeOld: removeOld);
        break;
      case LibraryFilterType.words:
        await getWords(removeOld: removeOld);
        break;
      case LibraryFilterType.downloads:
        await getDownloadedBooks();
        break;
    }
  }

  onSelectMenu(LibraryType onSelect) {
    switch (onSelect) {
      case LibraryType.removeDownload:
        getMyReads(removeOld: true);
        break;
      case LibraryType.viewSeries:
        getBookMarks(removeOld: true);
        break;
      case LibraryType.markAsFinished:
        getBookMarks(removeOld: true);
        break;
      case LibraryType.aboutILibrary:
        currentContext_!.pushNamed(AboutScreen.routeName);
        break;
    }
  }

  getMyReads({bool removeOld = false}) async {
    if (removeOld) {
      myReads = GenericPaginationModel<BookModel>();
      setState(() {
        loading = true;
      });
    }
    final result = await LibraryDataHandler.getMyReads(oldPagination: myReads);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = myReads.data;
      myReads = r;
      if (!removeOld) myReads.data.insertAll(0, oldItems);
      data = myReads.data;
    });
    if (!myReads.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  getBookMarks({bool removeOld = false}) async {
    if (removeOld) {
      bookMarks = GenericPaginationModel<BookModel>();

      setState(() {
        loading = true;
      });
    }
    final result =
        await LibraryDataHandler.getListMarks(oldPagination: bookMarks);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = bookMarks.data;
      bookMarks = r;
      if (!removeOld) bookMarks.data.insertAll(0, oldItems);
      data = bookMarks.data;
    });
    if (!bookMarks.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  getWishlist({bool removeOld = false}) async {
    if (removeOld) {
      wishList = GenericPaginationModel<BookModel>();
      setState(() {
        loading = true;
      });
    }
    final result =
        await LibraryDataHandler.getWishlist(oldPagination: wishList);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = wishList.data;
      wishList = r;
      if (!removeOld) wishList.data.insertAll(0, oldItems);
      data = wishList.data;
    });
    if (!wishList.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  getHighlights({bool removeOld = false}) async {
    if (removeOld) {
      highlights = GenericPaginationModel<BookModel>();
      setState(() {
        loading = true;
      });
    }
    final result =
        await LibraryDataHandler.getHighlights(oldPagination: highlights);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = highlights.data;
      highlights = r;
      if (!removeOld) highlights.data.insertAll(0, oldItems);
      data = highlights.data;
    });
    if (!highlights.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  getUserNotes({bool removeOld = false}) async {
    if (removeOld) {
      notes = GenericPaginationModel<BookNoteModel>();
      setState(() {
        loading = true;
      });
    }
    final result = await LibraryDataHandler.getUserNotes(oldPagination: notes);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = notes.data;
      notes = r;
      if (!removeOld) notes.data.insertAll(0, oldItems);
      notesList = notes.data;
    });
    if (!notes.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  Future<void> getDownloadedBooks() async {
    if(kIsWeb) return;
   downloadedBooks = await BookDbHelper().getAll();
   setState((){});
  }

  Future onDeleteDownloadedBook(int bookId) async {
    await BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () async {
            _onRemoveFromDownload(bookId);
            ElegantNotificationHelper.show(message: Strings.deletedSuccessfully.tr);
          },
          message: Strings.deleteFromDownloads.tr,
        ),
    );
  }

  Future _onRemoveFromDownload(int bookId)async{
    await Future.wait([
      BookDbHelper().delete(id: bookId),
      HighlightDbHelper().deleteByBookId(bookId: bookId),
      NoteDbHelper().deleteByBookId(bookId: bookId),
      BookStorageService.removeSavedBook(bookId: bookId),
    ]);
    await getDownloadedBooks();
  }


  getWords({bool removeOld = false}) async {
    if (removeOld) {
      words = GenericPaginationModel<DefinitionModel>();
      setState(() {
        loading = true;
      });
    }
    final result =
        await LibraryDataHandler.getDefinitions(oldPagination: words);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      final oldItems = words.data;
      words = r;
      if (!removeOld) words.data.insertAll(0, oldItems);
      definitionsList = words.data;
    });
    if (!words.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }

  //================onDeleteBookFromMyRead==================
  onDeleteMyRead(BookModel book) async {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () => deleteMyReadAPI(book),
          message: Strings.deleteFromMyReads.tr,
        ));
  }

  deleteMyReadAPI(BookModel book) async {
    loading = true;
    setState(() {});

    final result = await LibraryDataHandler.deleteMyReads(bookId: book.id);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      data.remove(book);
      deleteSuccessfully(Strings.deleteFromMyReadsSuccessfully.tr);
    });
    loading = false;
    setState(() {});
  }

//================onDeleteWord==================
  onDeleteWord(DefinitionModel definition) async {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () => deleteWordAPI(definition),
          message: Strings.deleteWords.tr,
        ));
  }

  deleteWordAPI(DefinitionModel definition) async {
    loading = true;
    setState(() {});

    final result = await GeneralDataHandler.deleteDefinitions(
        definitionsId: definition.id);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      definitionsList.remove(definition);
      deleteSuccessfully(Strings.deleteWordsSuccessfully.tr);
    });
    loading = false;
    setState(() {});
  }

//================onDeleteNote==================
  onDeleteNote(BookNoteModel note) async {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () => onDeleteNoteAPI(note),
          message: Strings.deleteNote.tr,
        ));
  }

  Future onDeleteNoteAPI(BookNoteModel note) async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.deleteNote(noteId: note.id!);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      notesList.remove(note);
      deleteSuccessfully(Strings.deleteNoteSuccessfully.tr);
    });
    setState(() {
      loading = false;
    });
  }

//================onDeleteHighLight==================
  onDeleteHighLight(BookModel book) async {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () => deleteHighLightAPI(book),
          message: Strings.deleteHighlights.tr,
        ));
  }

  Future deleteHighLightAPI(BookModel book) async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.deleteHighLight(
        highLightId: book.bookHighlightId!);
    result.fold((l) => ToastHelper.showError(message: l.message), (r) {
      data.remove(book);
      deleteSuccessfully(Strings.deleteHighlightsSuccessfully.tr);
    });
    setState(() {
      loading = false;
    });
  }
//============delete book mark
  deleteBookMark(BookModel book) async {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () => deleteBookMarkAPI(book),
          message: Strings.deleteBookMark.tr,
        ));
  }
  deleteBookMarkAPI(BookModel book) async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.deleteBookMark(
        bookMarkId: book.bookMarkId ?? 0);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      data.remove(book);
      deleteSuccessfully(Strings.deleteBookMarkSuccessfully.tr,);
    });
    setState(() {
      loading = false;
    });
  }
//==============deleteFromWishlist====================
  deleteFromWishlist(BookModel book) async {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () => onDeleteApi(book),
          message: Strings.deleteBookFromWishList.tr,
        ));
  }

  onDeleteApi(BookModel book) async {
    setState(() {
      loading = true;
    });
    final result = await GeneralDataHandler.deleteFromWishlist(bookId: book.id);
    result.fold((l) {
      ToastHelper.showError(message: l.message);
    }, (r) {
      data.remove(book);
      deleteSuccessfully(Strings.deletedSuccessfullyDes.tr);
    });
    setState(() {
      loading = false;
    });
  }

  deleteSuccessfully(String message) {
    DialogHelper.custom(context: currentContext_!).customDialog(
        dialogWidget: DeleteSuccessfullyWidget(
      message: message,
    ));
  }

}
