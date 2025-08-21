import 'dart:isolate';

import 'package:ELibrary/Models/read_book_style_model.dart';
import 'package:ELibrary/Modules/Book/ReadBook/read_book_controller.dart';
import 'package:ELibrary/Modules/Book/ReadBook/read_book_provider.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:ELibrary/Widgets/custom_button_widget.dart';
import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:state_extended/state_extended.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../Utilities/bottom_sheet_helper.dart';
import '../../../Widgets/overlay_blur_widget.dart';
import '../../../core/Caching/cached_books_helper.dart';
import '../../../generated/assets.dart';
import 'Widget/book_page_widget.dart';
import 'Widget/loading_book_widget.dart';
import 'Widget/read_book_appbar_widget.dart';
import 'Widget/read_book_navbar_widget.dart';

class ReadBookScreen extends StatefulWidget {
  static const routeName = "ReadBook";
  final int bookId;
  final String bookName;
  final String bookUrl;
  final int? startAt;
  final int? toHighlightId;
  final int? toNoteId;
  const ReadBookScreen({super.key, required this.bookId, required this.bookName, this.startAt, this.toHighlightId, this.toNoteId, required this.bookUrl});

  @override
  createState() => _ReadBookScreenState();
}

class _ReadBookScreenState extends StateX<ReadBookScreen> {
  _ReadBookScreenState() : super(controller: ReadBookController()) {
    con = ReadBookController();
  }

  late ReadBookController con;

  @override
  void initState() {
    con.init(widget.bookId,widget.bookUrl,startAt: widget.startAt,toHighlightId: widget.toHighlightId,toNoteId: widget.toNoteId);
    Provider.of<BottomSheetVisibilityProvider>(context, listen: false).updateBottomSheetVisibility(false);
    super.initState();
  }

  @override
  void dispose() {
    if(!kIsWeb) ScreenBrightness.instance.resetApplicationScreenBrightness();
    con.textSelectionOverlay?.remove();
    con.textSelectionOverlay = null;
    for(ScrollController s in con.scrollControllers) {s.dispose();}
    for(var q in con.quillControllers){q.dispose();}
    ReadBookController.htmlManipulationIsolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: ReadBookAppbarWidget(
          isDownloaded: con.isDownloadedLocally,
          onDownloadTap: con.onDownloadLocallyChange,
          screenName: widget.bookName,
          onTap: con.onChangeScroll,
          isVertical: con.isVertical,
        ),
        body: LoadingBookWidget(
          loading: con.loading,
          onRefresh: ()async=> await con.init(widget.bookId,widget.bookUrl,startAt: widget.startAt,toHighlightId: widget.toHighlightId,toNoteId: widget.toNoteId),
          child: OverlayBlurWidget(
            child: Consumer<ReadBookProvider>(
              builder: (context,rbProvider, child) {
                try {
                  if(!kIsWeb) ScreenBrightness.instance.setApplicationScreenBrightness(rbProvider.styleModel.brightness/100);
                } catch (_) {}
                if(con.isVertical) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: con.autoScrollController,
                    itemCount: con.quillControllers.length,
                    itemBuilder: (_,index){
                      return AutoScrollTag(
                        key: ValueKey(index),
                        index: index,
                        controller: con.autoScrollController,
                        child: Listener(
                          onPointerUp:(_)=> con.onPointerDown(context,_,index),
                          child: VisibilityDetector(
                            key: Key('VisibilityDetector_$index'),
                            onVisibilityChanged: (visibilityInfo) {
                              con.closeSelection(index);
                              if(visibilityInfo.visibleFraction>0.5){
                                con.currentPage = index;
                                CachedBooksHelper.cacheLastReadingPage(bookId: widget.bookId, pageNumber: index);
                                if(con.currentPage == con.quillControllers.length-1) con.finishReading();
                                setState((){});
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BookPageWidget(
                                  controller: con.quillControllers[index],
                                  scrollController: con.scrollControllers[index],
                                  styleModel: rbProvider.styleModel,
                                  contextMenuBuilder: ()=> con.getContextMenuWidget(index),
                                  disableScroll: con.isVertical,
                                  bookUrl: con.bookUrl,
                                ),
                                Container(
                                  color: rbProvider.styleModel.backgroundColor,
                                  padding: EdgeInsets.only(top: 8.h,bottom: 8.h),
                                  alignment: Alignment.center,
                                  child: PageNumberSearchableWidget(
                                    currentPage: index+1,
                                    totalPages: con.quillControllers.length,
                                    onSearch: (pageNumber)=> con.goToPagePage(pageNumber-1),
                                    styleModel: rbProvider.styleModel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: con.pageViewController,
                        scrollDirection: con.isVertical? Axis.vertical: Axis.horizontal,
                        itemCount: con.quillControllers.length,
                        pageSnapping: !con.isVertical,
                        onPageChanged: (currentPage){
                          con.currentPage = currentPage;
                          CachedBooksHelper.cacheLastReadingPage(bookId: widget.bookId, pageNumber: currentPage);
                          setState((){});
                        },
                        itemBuilder: (_,index){
                          return RawScrollbar(
                            thumbColor: rbProvider.styleModel.fontColor.withOpacity(0.5),
                            controller: con.scrollControllers[index],
                            thumbVisibility: true,
                            trackVisibility: false,
                            thickness: 8.w,
                            radius: Radius.circular(8.r),
                            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                            child: BookPageWidget(
                              controller: con.quillControllers[index],
                              scrollController: con.scrollControllers[index],
                              styleModel: rbProvider.styleModel,
                              contextMenuBuilder: ()=> con.getContextMenuWidget(index),
                              disableScroll: con.isVertical,
                              bookUrl: con.bookUrl,
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: ThemeClass.of(context).cartColor,width: 2.r)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(onTap: ()=> con.pageViewController.previousPage(duration: const Duration(milliseconds: 300),curve: Curves.easeInOutSine), child: Icon(Icons.arrow_back,color: ThemeClass.of(context).primaryColor,)),
                          Text("${con.currentPage+1} / ${con.quillControllers.length}",style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor,),),
                          InkWell(onTap: ()=> con.pageViewController.nextPage(duration: const Duration(milliseconds: 300),curve: Curves.easeInOutSine),child: Icon(Icons.arrow_forward,color: ThemeClass.of(context).primaryColor,)),
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
        bottomNavigationBar: ReadBookNavBarWidget(isCurrentBookMarked: con.currentPageBookMarked,),
      ),
    );
  }
}

class PageNumberSearchableWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onSearch;
  final ReadBookStyleModel styleModel;
  const PageNumberSearchableWidget({super.key, required this.currentPage, required this.totalPages, required this.onSearch, required this.styleModel});

  static TextEditingController searchPageController = TextEditingController();

  void _onSearch(BuildContext context) {
    int? searchPage = int.tryParse(searchPageController.text);
    if(searchPage != null && searchPage<=totalPages) {
      onSearch(searchPage);
      context.pop();
    } else {
      ToastHelper.showError(message: "please enter valid page number");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: (){
            BottomSheetHelper.bottomSheet(
              context: context,
              widget: const SizedBox(),
              builder: (context)=> Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: ThemeClass.of(context).cartColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                    border: Border.all(
                      width: 1.r,
                      color: ThemeClass.of(context).alertBackground,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFieldWidget(
                          autofocus: true,
                          controller: searchPageController,
                          textAlign: TextAlign.center,
                          onSave: (_) => _onSearch(context),
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.search,
                          formatter: [FilteringTextInputFormatter.digitsOnly],
                          borderColor: ThemeClass.of(context).primaryColor,
                          backGroundColor: ThemeClass.of(context).primaryColor.withOpacity(0.05),
                          borderRadiusValue: 10.r,
                          insidePadding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 12.w),
                          isDense: true,
                        ),
                      ),
                      Gap(16.w),
                      CustomButtonWidget.primary(
                        width: 48.r,
                        height: 48.r,
                        onTap: ()=> _onSearch(context),
                        child: SvgPicture.asset(Assets.imagesSearchIc,width: 22.r,height: 22.r,),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
            );
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: 60.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: ThemeClass.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1.2.r,color: ThemeClass.of(context).primaryColor),
            ),
            alignment: Alignment.center,
            child: Text(currentPage.toString(),style: TextStyleHelper.of(context).s16RegTextStyle.copyWith(color: styleModel.fontColor),),
          ),
        ),
        Text(" / $totalPages",
          style: TextStyleHelper.of(context).s18SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor,),
        ),
      ],
    );
  }
}
