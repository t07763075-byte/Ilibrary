import 'package:ELibrary/Modules/Account/HelpCenter/help_center_data_handler.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Models/faq_model.dart';
import '../../../Models/generic_pagination_model.dart';
import '../../../Utilities/enum.dart';
import '../../../Utilities/generic_file.dart';
import '../../../Utilities/strings.dart';
import '../../../Utilities/toast_helper.dart';

class HelpCenterController extends StateXController {
  // singleton
  factory HelpCenterController() => _this ??= HelpCenterController._();
  static HelpCenterController? _this;

  HelpCenterController._();

  bool loading = false, hasError = false, autoValidate = false;

  late TextEditingController subjectController, descriptionController, emailController;

  GenericPaginationModel<FAQModel> faqsPagination = GenericPaginationModel<FAQModel>();
  RefreshController refreshController = RefreshController(initialRefresh: false);

  List<GenericFile> files = [];

  ContactIssueType? selectedIssueType;
  String? privacyPolicyContent, termsConditionsContent;

  @override
  void initState() {
    subjectController = TextEditingController();
    descriptionController = TextEditingController();
    emailController = TextEditingController();
    super.initState();
  }

  Future getFAQsData({bool removeOld = false}) async {
    if(removeOld) faqsPagination = GenericPaginationModel<FAQModel>();
    if(faqsPagination.data.isEmpty) setState((){loading = true;});

    final result = await HelpCenterDataHandler.getFAQs(oldPagination: faqsPagination);
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) {
        final oldItems = faqsPagination.data;
        faqsPagination = r;
        if(!removeOld) faqsPagination.data.insertAll(0, oldItems);
    });

    if (!faqsPagination.hasNextPge) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    setState(() {
      loading = false;
    });
  }


  Future pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: [...GenericFile.imageExtensions,...GenericFile.documentExtensions],
      type: FileType.custom,
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      for (PlatformFile e in result.files) {
        try{
          if(e.bytes != null){
            files.add(GenericFile.fromPlatformFile(e));
          }else{
            files.add(await GenericFile.fromXFile(e.xFile));
          }
        }catch(_){
          ToastHelper.showError(message: "${e.name}: ${Strings.fileIsEmptyOrCorrupted.tr}");
        }
      }
    }
    setState((){});
  }

  Future onSubmitContact()async{
    if(selectedIssueType == null) return;
    setState(()=> loading = true);
    final result = await HelpCenterDataHandler.createTicket(
      issueType: selectedIssueType!.index + 1,
      subject: subjectController.text,
      description: descriptionController.text,
      email: emailController.text,
      documents: files
    );
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) {
        ToastHelper.showSuccess(message: Strings.dataChangedSuccessfully.tr);
        resetData();
      },
    );
    setState(()=> loading = false);
  }

  void resetData(){
    autoValidate = false;
    selectedIssueType = null;
    subjectController.clear();
    descriptionController.clear();
    emailController.clear();
    files = [];
  }

  Future getPrivacyPolicy() async {
    if(privacyPolicyContent != null) return;
    setState((){loading = true;});
    final result = await HelpCenterDataHandler.getPrivacyPolicy();
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) => privacyPolicyContent = r,
    );
    setState(() {loading = false;});
  }

  Future getTermsConditions() async {
    if(termsConditionsContent != null) return;
    setState((){loading = true;});
    final result = await HelpCenterDataHandler.getTermsConditions();
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r) => termsConditionsContent = r,
    );
    setState(() {loading = false;});
  }
}
