import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../core/API/request_on_progress_provider.dart';
import '../html_manipulation_helper.dart';

class LoadingBookWidget extends StatelessWidget {
  final Widget child;
  final bool loading;
  final Function()? onRefresh;
  const LoadingBookWidget({super.key, required this.child, required this.loading, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BookProcessingProvider,DownloadRequestProgressProvider>(
      builder: (_, bookPP,downloadRPP,ch) {
        return LoadingScreen(
          loading: loading && bookPP.processingPage == null && downloadRPP.progress == 1,
          onRefresh: onRefresh,
          child: Stack(
            alignment: Alignment.center,
            children: [
              child,

              if(bookPP.processingPage != null || downloadRPP.progress != 1) Positioned.fill(
                child: Container(
                  color: ThemeClass.of(context).backGroundColor.withOpacity(.2),
                ),
              ),
              if(bookPP.processingPage != null || downloadRPP.progress != 1) Positioned(
                child: Container(
                  height: 80.w,
                  width: 240.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    bookPP.processingPage != null?
                    "Processing book: ${bookPP.processingPage} / ${bookPP.totalPages}":
                    "Downloading book: ${(downloadRPP.progress * 100).toStringAsFixed(2)} %",style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
