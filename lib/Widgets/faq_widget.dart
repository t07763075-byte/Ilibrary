import 'package:ELibrary/Models/faq_model.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Utilities/text_style_helper.dart';
import '../generated/assets.dart';

class FAQWidget extends StatefulWidget {
  final FAQModel faqModel;
  const FAQWidget({super.key, required this.faqModel});

  @override
  State<FAQWidget> createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeClass.of(context).alertBackground,),
        borderRadius: BorderRadius.circular(16.r),
        color: ThemeClass.of(context).cartColor
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _toggleExpanded,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.faqModel.question ?? "",style: TextStyleHelper.of(context).s18SemiBoldTextStyle,),
                SvgPicture.asset(Assets.imagesCustomArrowDown),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: _isExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isExpanded ? 1 : 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: ThemeClass.of(context).alertBackground,height: 32.h,thickness: 1.2.r,),
                    Text(widget.faqModel.answer ?? "",style: TextStyleHelper.of(context).s14SemiBoldTextStyle,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
