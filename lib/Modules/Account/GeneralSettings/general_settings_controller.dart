import 'package:ELibrary/Widgets/change_language_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/bottom_sheet_helper.dart';
import '../../../Utilities/router_config.dart';
import '../../../core/Language/app_languages.dart';

class GeneralSettingsController extends StateXController {
  // singleton
  factory GeneralSettingsController() => _this ??= GeneralSettingsController._();
  static GeneralSettingsController? _this;

  GeneralSettingsController._();

  Future onConfirm(Languages selectedLanguage) async {
    final appLan = Provider.of<AppLanguage>(currentContext_!, listen: false);
    await appLan.changeLanguage(language: selectedLanguage);
    setState(() {});
    currentContext_!.pop();
  }

  Future onChangeLanguage() async{
    await BottomSheetHelper.bottomSheet(
      context: currentContext_!,
      onDismiss: () {
        setState(() {});
      },
      widget: ChangeLanguageWidget(
        onConfirm: onConfirm,
      ),
    );
  }



}
