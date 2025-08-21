import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';
import '../../../../Widgets/faq_widget.dart';
import '../../../../Widgets/pagination_widget.dart';
import '../help_center_controller.dart';

class FAQsScreen extends StatefulWidget {
  static const routeName = "FAQsScreen";

  const FAQsScreen({super.key});

  @override
  createState() => _FAQsScreenState();
}

class _FAQsScreenState extends StateX<FAQsScreen> {
  _FAQsScreenState() : super(controller: HelpCenterController()) {
    con = HelpCenterController();
  }

  late HelpCenterController con;

  @override
  void initState() {
    super.initState();
    if(con.faqsPagination.data.isEmpty) con.getFAQsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(screenName: Strings.faq.tr,),
      body: LoadingScreen(
        loading: con.loading,
        child: PaginationWidget(
          onLoading: con.getFAQsData,
          refreshController: con.refreshController,
          refresh: ()=>con.getFAQsData(removeOld: true),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            itemCount: con.faqsPagination.data.length,
            itemBuilder: (_, index) => FAQWidget(faqModel: con.faqsPagination.data[index]),
            separatorBuilder: (_,index)=> Gap(24.h),
          ),
        ),
      ),
    );
  }
}
