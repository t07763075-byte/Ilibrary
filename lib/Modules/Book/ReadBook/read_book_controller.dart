import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'package:ELibrary/LocalDatabase/Tables/book_db_table.dart';
import 'package:ELibrary/LocalDatabase/book_storage_service.dart';
import 'package:ELibrary/Models/book_highlight_model.dart';
import 'package:ELibrary/Models/book_mark_model.dart';
import 'package:ELibrary/Models/book_model.dart';
import 'package:ELibrary/Modules/Book/ReadBook/ReadBookDataHandler/manager_data_handler.dart';
import 'package:ELibrary/Modules/Book/ReadBook/read_book_provider.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:ELibrary/Utilities/router_config.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Models/book_note_model.dart';
import '../../../Models/book_text_address.dart';
import '../../../Models/language_model.dart';
import '../../../Utilities/bottom_sheet_helper.dart';
import '../../../Utilities/dialog_helper.dart';
import '../../../Utilities/elegant_notification.dart';
import '../../../Utilities/general_data_handler.dart';
import '../../../Widgets/delete_alert_widget.dart';
import '../../../core/Caching/cached_books_helper.dart';
import '../../MyLibrary/Library/library_controller.dart';
import 'Widget/actions_list_widget.dart';
import 'Widget/definition_widget.dart';
import 'Widget/note_details_widget.dart';
import 'Widget/text_selection_actions_widget.dart';
import 'Widget/explanation_widget.dart';
import 'Widget/take_note_widget.dart';
import 'Widget/translate_widget.dart';
import 'package:html/dom.dart' as dom;
import 'html_manipulation_helper.dart';

class ReadBookController extends StateXController {
  // singleton
  factory ReadBookController() => _this ??= ReadBookController._();
  static ReadBookController? _this;

  ReadBookController._();

  late ReadBookDataHandlerManage readBookDataHandlerManage;
  
  bool loading = false, isVertical = true, isCalledFinishReading = false,isDownloadedLocally = false;
  late int bookId;
  late String bookUrl;
  PageController pageViewController = PageController(
    initialPage: 0,
  );
  AutoScrollController autoScrollController = AutoScrollController(
    viewportBoundaryGetter: () => const Rect.fromLTRB(0, 0, 0, 0),
    axis: Axis.vertical,
  );
  List<String> _htmlBookPages = [];
  List<QuillController> quillControllers = [];
  List<BookHighlightModel> highlightsList = [];
  List<BookNoteModel> notesList = [];
  List<BookMarkModel> bookMarkList = [];
  List<ScrollController> scrollControllers = [];
  int currentPage = 0;
  OverlayEntry? textSelectionOverlay;
  static FlutterIsolate? htmlManipulationIsolate;

  bool get currentPageBookMarked => bookMarkList.any((e) => e.page == currentPage);

  void closeSelection(int i) {
    try{
      if (getSelectedText(i).isEmpty) return;
      quillControllers[i].updateSelection(
          const TextSelection.collapsed(offset: 0), ChangeSource.local);
      textSelectionOverlay?.remove();
      textSelectionOverlay = null;
    }catch(_){}
  }

  Future goToPagePage(int page, {AutoScrollPosition? scrollPosition}) async {
    if (isVertical) {
      double offset = page * getPageHeight;
      scrollToPosition(offset, () async {
        await autoScrollController.scrollToIndex(page,
            duration: const Duration(milliseconds: 50),
            preferPosition: scrollPosition ?? AutoScrollPosition.begin);
        await autoScrollController.highlight(page, animated: true);
      });
    } else {
      pageViewController.jumpToPage(page);
    }
  }

  double get getPageHeight {
    final rbProvider =
        Provider.of<ReadBookProvider>(currentContext_!, listen: false);
    double pageHeight = 700.h;
    double fontFactor = rbProvider.styleModel.fontSizeFactor;
    return pageHeight * fontFactor;
  }

  void scrollToPosition(double position, VoidCallback onComplete) {
    void listener() async {
      if (autoScrollController.position.pixels == position) {
        autoScrollController.removeListener(listener); // Clean up the listener
        await Future.delayed(const Duration(milliseconds: 100));
        onComplete();
      }
    }

    autoScrollController.addListener(listener);
    autoScrollController.jumpTo(position);
  }

  void openHighLightsList() {
    closeSelection(currentPage);
    BottomSheetHelper.bottomSheet(
      context: currentContext_!,
      widget: ActionsListWidget<BookHighlightModel>(
        title: Strings.highlights.tr,
        items: highlightsList,
        onDelete: onDeleteHighLight,
        onSelect: goToTextAddress,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void openNotesList() {
    closeSelection(currentPage);
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: ActionsListWidget<BookNoteModel>(
          title: Strings.notes.tr,
          items: notesList,
          onDelete: onDeleteNote,
          onSelect: goToTextAddress,
        ),
        backgroundColor: Colors.transparent);
  }

  void onChangeScroll() {
    isVertical = !isVertical;
    setState(() {});
    ElegantNotificationHelper.show(
      message: !isVertical ? Strings.flippingMod.tr : Strings.scrollMode.tr,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      goToPagePage(currentPage);
    });
  }

  Future<void> init(int bookId, String bookUrl, {int? startAt, int? toHighlightId, int? toNoteId}) async {
    this.bookId = bookId;
    this.bookUrl = bookUrl;
    readBookDataHandlerManage = ReadBookDataHandlerManage(isSavedLocal: await BookDbHelper.canUseLocalDB(bookId: bookId));
    reset();
    checkDownloadedLocally();
    setState(() => loading = true);

    await Future.wait([
      getBookData(),
      getHighlightsList(),
      getNotesList(),
      getBookMarkList(),
    ]);
    for (int i = 0; i < _htmlBookPages.length; i++) {
      Document page;
      try {
        page = Document.fromDelta(HtmlToDelta(replaceNormalNewLinesToBr: true, customBlocks: [TableCustomHtmlPart(), CustomTagIdHtmlPart()]).convert(_htmlBookPages[i]));
      } catch (_) {
        page = Document.fromDelta(HtmlToDelta().convert("<h1>ERROR ON THIS PAGE</h1><p><br></p>"));
      }
      quillControllers.add(QuillController(
        document: page,
        readOnly: true,
        selection: const TextSelection.collapsed(offset: 0),
      ));
    }
    scrollControllers = List.generate(quillControllers.length, (_) => ScrollController()).toList();
    for (int i = 0; i < quillControllers.length; i++) {
      addHighlightsToPage(i);
      addNotesToPage(i);
    }
    int? startFromPage = startAt ?? CachedBooksHelper.getCachedLastReadingPage(bookId);
    await Future.delayed(const Duration(milliseconds: 100));

    if (startFromPage != null && toHighlightId == null && toNoteId == null) await goToPagePage(startFromPage);

    final BookHighlightModel? toHighLight =
        highlightsList.firstWhereOrNull((e) => e.id == toHighlightId);
    if (toHighLight != null) await goToTextAddress(toHighLight, withBack: false);

    final BookNoteModel? toNote =
        notesList.firstWhereOrNull((e) => e.id == toNoteId);
    if (toNote != null) await goToTextAddress(toNote, withBack: false);
    setState(() => loading = false);
  }

  Future checkDownloadedLocally()async{
    if(kIsWeb) return;
    BookModel? result = await BookDbHelper().getById(id: bookId);
    isDownloadedLocally = result != null;
    setState((){});
  }

  Future<void> onDownloadLocallyChange()async{
    if(!isDownloadedLocally){
      setState((){loading = true;});
      final result = await GeneralDataHandler.getBookDetails(bookId: bookId.toString());
      setState((){loading = false;});
      if(result.isLeft()) return;
      await BookDbHelper().insert(book: result.getOrElse(()=> BookModel()));
      await BookStorageService.saveBook(bookId: bookId);
      ReadBookDataHandlerManage(isSavedLocal: true).getHighlightsList(bookId: bookId);
      ReadBookDataHandlerManage(isSavedLocal: true).getNotesList(bookId: bookId);
      checkDownloadedLocally();
    }else{
      await LibraryController().onDeleteDownloadedBook(bookId);
      await checkDownloadedLocally();
    }
  }

  void reset() {
    isCalledFinishReading = false;
    currentPage = 0;
    _htmlBookPages = [];
    quillControllers = [];
    scrollControllers = [];
    highlightsList = [];
    notesList = [];
    pageViewController = PageController(
      initialPage: 0,
    );
  }

  Future getBookData() async {
    final bookProcessingProvider = Provider.of<BookProcessingProvider>(currentContext_!, listen: false);
    bookProcessingProvider.updateTotalPages(totalPages: null);
    bookProcessingProvider.updateProcessingPage(processingPage: null);
    final result = await readBookDataHandlerManage.getBookById(bookId: bookId);
    result.fold((l) => ToastHelper.showError(message: l.message),
        (r) => _htmlBookPages = r);
  }

  Future getHighlightsList() async {
    final result = await readBookDataHandlerManage.getHighlightsList(bookId: bookId);
    result.fold((l) => ToastHelper.showError(message: l.message),
        (r) => highlightsList = r);
  }

  Future getNotesList() async {
    final result = await readBookDataHandlerManage.getNotesList(bookId: bookId);
    result.fold(
        (l) => ToastHelper.showError(message: l.message), (r) => notesList = r);
  }

  Future getBookMarkList() async {
    final result = await readBookDataHandlerManage.getBookMarkList(bookId: bookId);
    result.fold((l) => ToastHelper.showError(message: l.message),
        (r) => bookMarkList = r);
  }

  void addHighlightsToPage(int pageIndex) {
    List<BookHighlightModel> highlightsForPageNumber = highlightsList.where((e) => e.page == pageIndex).toList().reversed.toList();
    for (BookHighlightModel highlight in highlightsForPageNumber) {
      if (highlight.selection == null) continue;
      quillControllers[pageIndex].updateSelection(highlight.selection!, ChangeSource.remote);
      quillControllers[pageIndex].formatSelection(BackgroundAttribute(highlight.color));
      closeSelection(pageIndex);
    }
  }

  Future addNotesToPage(int pageIndex) async {
    List<BookNoteModel> notesForPageNumber =
        notesList.where((e) => e.page == pageIndex).toList().reversed.toList();
    for (BookNoteModel note in notesForPageNumber) {
      if (note.selection == null) continue;
      try {
        if (note.noteIndex == null) continue;
        addNoteToSelection(note);
      } catch (_) {}
    }
  }

  String getSelectedText(int pageIndex) =>
      quillControllers[pageIndex].document.getPlainText(
          quillControllers[pageIndex].selection.start,
          quillControllers[pageIndex].selection.end -
              quillControllers[pageIndex].selection.start);

  void showTextSelectionOverlay(
      {required int pageIndex, required RelativeRect position}) {
    textSelectionOverlay?.remove();
    textSelectionOverlay = null;
    if (getSelectedText(pageIndex).isEmpty) return;
    textSelectionOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: position.top,
        left: position.left,
        right: position.right,
        bottom: position.bottom,
        child: Center(child: getContextMenuWidget(pageIndex)),
      ),
    );
    Navigator.of(currentContext_!).overlay!.insert(textSelectionOverlay!);
  }

  Widget getContextMenuWidget(int pageIndex) {
  return Builder(
    builder: (context) => BookDialogActionsWidget(
      showWordDefinition: !getSelectedText(pageIndex).contains(" "),
      onHighlight: (color) => onHighlight(color: color, pageIndex: pageIndex),
      onAddNote: (Offset position) => onAddNote(pageIndex: pageIndex, position: position),
      onTranslate: () => onTranslate(pageIndex: pageIndex),
      onExplain: () => explainLanguage(pageIndex: pageIndex),
      onDefinition: () => onDefinition(pageIndex: pageIndex),
    ),
  );
}

  Future onHighlight({required String color, required int pageIndex}) async {
    BookHighlightModel? oldHighlightModel =
        highlightsList.singleWhereOrNull((e) {
      return (e.page == pageIndex &&
          e.selection != null &&
          e.selection!.start == quillControllers[pageIndex].selection.start &&
          e.selection!.end == quillControllers[pageIndex].selection.end);
    });
    if (oldHighlightModel != null) await editOldHighLight(color: color, highlightModel: oldHighlightModel);
    if (oldHighlightModel == null) await addNewHighLight(color: color, pageIndex: pageIndex);
    setState(() {});
  }

  Future addNewHighLight({required String color, required int pageIndex}) async {
    String selectedText = getSelectedText(pageIndex);
    BookHighlightModel highlightModel = BookHighlightModel(
      localActionType: LocalActionType.add,
      bookId: bookId,
      page: pageIndex,
      selection: quillControllers[pageIndex].selection,
      color: color,
      title: selectedText,
      date: DateTime.now(),
    );
    final result = await readBookDataHandlerManage.addHighlight(highlight: highlightModel);
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) {
        ElegantNotificationHelper.show(message: Strings.highlightSuccessfully.tr);
        quillControllers[pageIndex].formatSelection(BackgroundAttribute(color));
        highlightsList.insert(0, r);
      },
    );
  }

  Future editOldHighLight({required String color, required BookHighlightModel highlightModel}) async {
    final result = await readBookDataHandlerManage.editHighlight(
      highLightId: highlightModel.id!,
      color: color,
    );
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (_) {
        ElegantNotificationHelper.show(
            message: Strings.highlightSuccessfully.tr);
        highlightModel = highlightModel.copyWith(color: color);
        highlightsList = highlightsList
            .map((e) =>
                e.copyWith(color: e.id == highlightModel.id ? color : null))
            .toList();
        quillControllers[highlightModel.page!]
            .formatSelection(BackgroundAttribute(color));
      },
    );
  }

  Future onAddNote({required int pageIndex, required Offset position}) async {
  String selectedText = getSelectedText(pageIndex);
  TextSelection textSelection = quillControllers[pageIndex].selection;
  DialogHelper.custom(currentContext_!).customDialogPosition(
    top: position.dy,
    left: position.dx,
    dialogWidget: TakeNoteWidget(
      onSave: (note) async {
        int noteIndex = textSelection.start + selectedText.lastIndexOf(" ");
        BookNoteModel noteModel = BookNoteModel(
          localActionType: LocalActionType.add,
          bookId: bookId,
          page: pageIndex,
          noteIndex: noteIndex,
          selection: textSelection,
          title: selectedText,
          info: note,
          date: DateTime.now(),
        );
        final result = await readBookDataHandlerManage.addNote(noteModel: noteModel,);
        result.fold((l) => ToastHelper.showError(message: l.message), (r) {
          ElegantNotificationHelper.show(message: Strings.noteSuccessfully.tr);
          notesList.insert(0, r);
          addNoteToSelection(r);
        });
        setState(() {});
      },
    ),
  );
}

  void addNoteToSelection(BookNoteModel note) {
    quillControllers[note.page!]
        .updateSelection(note.selection!, ChangeSource.local);
    quillControllers[note.page!]
        .formatSelection(const ColorAttribute("#483D8B"));
    quillControllers[note.page!]
        .formatSelection(const BackgroundAttribute("#E6E6FA"));
    quillControllers[note.page!].formatSelection(const FontAttribute("Arial"));
    quillControllers[note.page!]
        .formatSelection(LinkAttribute("note:${json.encode(note.toJson())}"));
  }

  void resetNote(BookNoteModel note) {
    quillControllers[note.page!]
        .updateSelection(note.selection!, ChangeSource.local);
    quillControllers[note.page!].formatSelection(const ColorAttribute(null));
    quillControllers[note.page!]
        .formatSelection(const BackgroundAttribute(null));
    quillControllers[note.page!].formatSelection(const FontAttribute(null));
    quillControllers[note.page!].formatSelection(const LinkAttribute(null));
  }

  Future onEditNote({required BookNoteModel noteModel}) async {
    if(noteModel.id == null) return;
    BottomSheetHelper.bottomSheet(
      context: currentContext_!,
      widget: TakeNoteWidget(
        initialNote: noteModel.info,
        onSave: (note) async {
          final result = await readBookDataHandlerManage.editNote(
            id: noteModel.id!,
            note: note,
          );
          result.fold((l) => ToastHelper.showError(message: l.message), (r) {
            ElegantNotificationHelper.show(message: Strings.noteSuccessfully.tr);
            noteModel = noteModel.copyWith(info: note);
            notesList = notesList.map((e) => e.copyWith(info: e.id == noteModel.id ? note : null)).toList();
            addNoteToSelection(noteModel);
          });
          setState(() {});
        },
      ),
    );
  }

  Future onTranslate({required int pageIndex}) async {
    await BottomSheetHelper.bottomSheet(
      context: currentContext_!,
      widget: TranslateWidget(
        selectedText: getSelectedText(pageIndex),
      ),
    );
  }

  explainLanguage({required int pageIndex}) async {
    await BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: SelectExplainLanguage(
          onSelectLanguage: (language) {
            currentContext_!.pop();
            onExplain(language: language, pageIndex: pageIndex);
          },
        ));
  }

  Future onExplain(
      {required int pageIndex, required LanguageModel language}) async {
    String explain = "";
    setState(() => loading = true);
    final result = await ReadBookDataHandlerManage.explain(
        bookId: bookId,
        selectedText: getSelectedText(pageIndex),
        languageId: language.id);
    result.fold(
        (l) => ToastHelper.showError(message: l.message), (r) => explain = r);
    setState(() => loading = false);
    closeSelection(pageIndex);
    if (explain.isEmpty) return;
    await BottomSheetHelper.bottomSheet(
      context: currentContext_!,
      widget: ExplanationWidget(explanation: explain),
    );
  }

  Future onDefinition({required int pageIndex}) async {
    String selectedText = getSelectedText(pageIndex);
    closeSelection(pageIndex);
    await BottomSheetHelper.bottomSheet(
      context: currentContext_!,
      widget: DefinitionWidget(
        bookId: bookId,
        selectedWord: selectedText,
        onSave: (definition) async {
          final result = await ReadBookDataHandlerManage.saveDefinition(
              definitionId: definition.id);
          result.fold(
            (l) => ToastHelper.showError(message: l.message),
            (r) => ToastHelper.showSuccess(
                message: Strings.submittedSuccessfully.tr),
          );
        },
      ),
    );
  }

//================onDeleteNote==================
  Future onDeleteNote(BookNoteModel note) async {
    BottomSheetHelper.bottomSheet(
      context: currentContext_!,
      widget: DeleteAlertWidget(
        onDelete: () => onDeleteNoteAPI(note),
        message: Strings.deleteNote.tr,
      ),
    );
  }

  Future onDeleteNoteAPI(BookNoteModel note) async {
    if (note.id == null) return;
    final result = await readBookDataHandlerManage.deleteNote(id: note.id!);
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) => ElegantNotificationHelper.show(message: Strings.deletedSuccessfully.tr),
    );
    if (result.isRight()) {
      notesList.removeWhere((e) => e.id == note.id);
      if (note.selection == null || note.page == null) return;

      resetNote(note);
      setState(() {});
    }
  }

//================onDeleteHighLight==================
  Future onDeleteHighLight(BookHighlightModel highlight) async {
    BottomSheetHelper.bottomSheet(
      context: currentContext_!,
      widget: DeleteAlertWidget(
        onDelete: () => deleteHighLightAPI(highlight),
        message: Strings.deleteHighlights.tr,
      ),
    );
  }

  Future deleteHighLightAPI(BookHighlightModel highlight) async {
    if (highlight.id == null) return;
    final result = await readBookDataHandlerManage.deleteHighlight(id: highlight.id!);
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) => ElegantNotificationHelper.show(message: Strings.deletedSuccessfully.tr),
    );

    if (result.isRight()) {
      highlightsList.removeWhere((e) => e.id == highlight.id);
      if (highlight.selection == null || highlight.page == null) return;
      quillControllers[highlight.page!].formatText(0, quillControllers[highlight.page!].document.length, const BackgroundAttribute(null));
      addHighlightsToPage(highlight.page!);
      closeSelection(highlight.page!);
    }
  }

//==============================================
  Future<void> onBookmarkChange() async {
    if (!currentPageBookMarked) {
      setState(() {loading = true;});
      final result = await readBookDataHandlerManage.addBookMark(bookId: bookId, pageIndex: currentPage);
      result.fold(
        (l) => ToastHelper.showError(message: l.message),
        (r) {
          ElegantNotificationHelper.show(message: Strings.submittedSuccessfully.tr);
          bookMarkList.add(r);
        },
      );
      setState(() {loading = false;});
    } else {
      BookMarkModel? currentMark = bookMarkList.firstWhereOrNull((e) => e.page == currentPage);
      if (currentMark?.id == null) return;
      setState(() {loading = true;});
      final result = await GeneralDataHandler.deleteBookMark(bookMarkId: currentMark!.id!);
      result.fold(
        (l) => ToastHelper.showError(message: l.message),
        (r) => bookMarkList.removeWhere((e) => e.id == currentMark.id),
      );
      setState(() {loading = false;});
    }
  }

  Future goToTextAddress(BookTextAddress textAddress,
      {bool withBack = true}) async {
    if (textAddress.page == null) return;
    if (withBack) currentContext_?.pop();
    await goToPagePage(textAddress.page!,
        scrollPosition: getScrollPosition(textAddress));
    if (textAddress.selection != null) quillControllers[textAddress.page!].updateSelection(textAddress.selection!, ChangeSource.local);
    if (!isVertical) scrollToSelectedTextByIndex(textAddress);
  }

  void scrollToSelectedTextByIndex(BookTextAddress textAddress) {
    double maxOffset =
        scrollControllers[textAddress.page!].position.maxScrollExtent;

    int pageTextLength =
        quillControllers[textAddress.page!].document.toPlainText().length;
    double textPositionApproximately =
        textAddress.selection!.start / pageTextLength;

    double textOffset = maxOffset * textPositionApproximately;
    scrollControllers[textAddress.page!].animateTo(textOffset,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInSine);
  }

  AutoScrollPosition? getScrollPosition(BookTextAddress textAddress) {
    if (!isVertical) return null;
    int pageTextLength =
        quillControllers[textAddress.page!].document.toPlainText().length;
    double textPositionApproximately =
        textAddress.selection!.start / pageTextLength;

    if (textPositionApproximately <= 0.334) return AutoScrollPosition.begin;
    if (textPositionApproximately <= 0.667) return AutoScrollPosition.middle;
    return AutoScrollPosition.end;
  }

  void openNoteDialog(BookNoteModel noteModel) {
    DialogHelper.custom(context: currentContext_!).customDialog(
      dialogWidget: NoteDetailsWidget(
        note: noteModel,
        onEdit: () {
          currentContext_?.pop();
          onEditNote(noteModel: noteModel);
        },
      ),
    );
  }

  Future finishReading() async {
    if (isCalledFinishReading) return;
    final result = await ReadBookDataHandlerManage.finishedRead(bookId: bookId);
    if (result.isRight()) isCalledFinishReading = true;
  }

  void scrollToElementId(String elementId) {
    log(elementId);
    if (elementId.startsWith("toPage:")) {
      int? page = int.tryParse(elementId.split(":")[1]);
      if (page != null) goToPagePage(page);
    } else {
      for (int i = 0; i < quillControllers.length; i++) {
        Delta delta = quillControllers[i].document.toDelta();
        for (var operation in delta.toList()) {
          if (operation.data is Map &&
              (operation.data as Map)["TagId"] != null) {
            dom.Element element =
                ((operation.data as Map)["TagId"] as dom.Element);
            if (element.id == elementId) goToPagePage(i);
            break;
          }
        }
      }
    }
  }

  Future<void> onPointerDown(context, PointerEvent event, int pageIndex) async {
    if (!kIsWeb) return;
    Size screenSize = MediaQuery.sizeOf(context);
    await Future.delayed(Duration.zero);
    showTextSelectionOverlay(
        pageIndex: pageIndex,
        position: RelativeRect.fromSize(
            event.position & Size(340.w, 40.h), screenSize));
  }

  static Future<List<String>> parseHtmlInIsolate({required String htmlBook,}) async {
    final completer = Completer<List<String>>();
    final port = ReceivePort();


    port.listen((msg) {
      if (msg is Map && msg["progress"] != null) {
        final bookProcessingProvider = Provider.of<BookProcessingProvider>(currentContext_!, listen: false);
        bookProcessingProvider.updateTotalPages(totalPages: msg["progress"]["totalPages"]);
        bookProcessingProvider.updateProcessingPage(processingPage: msg["progress"]["processingPage"]);
      } else if (msg is Map && msg["result"] != null) {
        completer.complete(List<String>.from(msg["result"]));
        port.close();
      } else if (msg is Map && msg["error"] != null) {
        completer.completeError(msg["error"]);
        port.close();
      }
    });

    htmlManipulationIsolate = await FlutterIsolate.spawn(
      HtmlManipulationHelper.getPagesFromHtmlBook,
      {
        "port": port.sendPort,
        "htmlBook": htmlBook,
      },
    );

    return completer.future.timeout(const Duration(minutes: 1));
  }
}
