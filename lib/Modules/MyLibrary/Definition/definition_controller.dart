import 'package:ELibrary/Models/definition_model.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Utilities/bottom_sheet_helper.dart';
import '../../../Utilities/dialog_helper.dart';
import '../../../Utilities/general_data_handler.dart';
import '../../../Utilities/router_config.dart';
import '../../../Utilities/strings.dart';
import '../../../Utilities/toast_helper.dart';
import '../../../Widgets/delete_alert_widget.dart';
import '../../../Widgets/delete_successfully_widget.dart';
import '../Library/library_controller.dart';

class DefinitionController extends StateXController {
  // singleton
  factory DefinitionController() => _this ??= DefinitionController._();
  static DefinitionController? _this;

  DefinitionController._();

  bool loading = false;
  DefinitionModel? definition;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  onDeleteWord(DefinitionModel definition) async {
    BottomSheetHelper.bottomSheet(
        context: currentContext_!,
        widget: DeleteAlertWidget(
          onDelete: () => deleteWord(),
          message: Strings.deleteWords.tr,
        ));
  }
  deleteWord() async {
    loading = true;
    setState(() {});

    final result=await GeneralDataHandler.deleteDefinitions(definitionsId: definition?.id);
    result.fold((l){
      ToastHelper.showError(message: l.message);
    }, (r){
      LibraryController().getWords(removeOld: true);
      deleteSuccessfully();
    });
    loading = false;
    setState(() {});
  }
  deleteSuccessfully() {
    DialogHelper.custom(context: currentContext_!)
        .customDialog(dialogWidget:  DeleteSuccessfullyWidget(
      message:Strings.deleteWordsSuccessfully.tr ,
      onBack: (){
        currentContext_!.pop();
        currentContext_!.pop();
      },
    ));
  }
}
