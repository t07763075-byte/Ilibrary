import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/text_style_helper.dart';
import '../../../Utilities/theme_helper.dart';
import 'general_settings_controller.dart';

class GeneralSettingsScreen extends StatefulWidget {
  static const routeName = "generalSettingsScreen";

  const GeneralSettingsScreen({super.key});

  @override
  createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends StateX<GeneralSettingsScreen> {
  _GeneralSettingsScreenState() : super(controller: GeneralSettingsController()) {
    con = GeneralSettingsController();
  }

  late GeneralSettingsController con;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(screenName: AppLocalizations.of(context)!.translate(Strings.generalSettings)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 32.h),
        child: Column(
          children: [
            GeneralSettingsWidget(
              title: Strings.language.tr,
              onTap: con.onChangeLanguage,
            ),
          ],
        ),
      ),
    );
  }
}

class GeneralSettingsWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  const GeneralSettingsWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Expanded(child: Text(title,style: TextStyleHelper.of(context).s20SemiBoldTextStyle,)),
            Icon(Icons.arrow_forward_ios,color: ThemeClass.of(context).mainTextColor,size: 20.r,)
          ],
        ),
      ),
    );
  }
}

