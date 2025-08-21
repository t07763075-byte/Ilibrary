import 'package:ELibrary/Utilities/api_end_point.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:state_extended/state_extended.dart';
import '../../../../Models/read_book_style_model.dart';
import '../../../Book/ReadBook/Widget/book_page_widget.dart';
import '../../../Book/ReadBook/html_manipulation_helper.dart';
import '../help_center_controller.dart';

class TermsConditionsScreen extends StatefulWidget {
  static const routeName = "TermsConditionsScreen";

  const TermsConditionsScreen({super.key});

  @override
  createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends StateX<TermsConditionsScreen> {
  _TermsConditionsScreenState() : super(controller: HelpCenterController()) {
    con = HelpCenterController();
  }

  late HelpCenterController con;

  @override
  void initState() {
    con.getTermsConditions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(screenName: Strings.termsAndConditions.tr,),
      body: LoadingScreen(
        loading: con.loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 32.h),
          child: BookPageWidget(
            controller: QuillController(
              document: Document.fromDelta(HtmlToDelta(replaceNormalNewLinesToBr: true, customBlocks: [TableCustomHtmlPart(), CustomTagIdHtmlPart()]).convert(con.termsConditionsContent ?? "<p><br></p>")),
              readOnly: true,
              selection: const TextSelection.collapsed(offset: 0),
            ),
            scrollController: ScrollController(),
            styleModel: ReadBookStyleModel.defaultStyle,
            disableScroll: false,
            disableCustomStyle: true,
            bookUrl: APIEndPoint.termsConditionsPage,
            contextMenuBuilder: ()=> const SizedBox(),
          ),
        ),
      ),
    );
  }
}
