import 'dart:io';
import 'package:ELibrary/Utilities/dialog_helper.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/toast_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:flutter/cupertino.dart';
import 'package:state_extended/state_extended.dart';
import '../../../Models/user_model.dart';
import '../../../Utilities/format_date_helper.dart';
import '../../../Utilities/pick_media_helper.dart';
import '../../../Utilities/router_config.dart';
import '../../../Widgets/custom_calender_widget.dart';
import 'edit_profile_data_handler.dart';

class EditProfileController extends StateXController {
  // singleton
  factory EditProfileController() => _this ??= EditProfileController._();
  static EditProfileController? _this;

  EditProfileController._();

  bool loading = false, autoValidate = false;

  bool get isSomethingChange{
    if(personalImage != null) return true;
    if(firstNameController.text != userModel?.firstName) return true;
    if(lastNameController.text != userModel?.lastName) return true;
    if(birthday != userModel?.birthDate) return true;
    return false;
  }

  String phoneCountryCode = "+20";
  File? personalImage;
  DateTime? birthday;

  late TextEditingController firstNameController, lastNameController, emailController,
      phoneNumController, birthDateController;

  UserModel? userModel;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    birthDateController = TextEditingController();
    phoneNumController = TextEditingController();

    firstNameController.addListener(updateIsSomethingChange);
    lastNameController.addListener(updateIsSomethingChange);
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  void updateIsSomethingChange()=> setState((){});

  Future init()async{
    resetData();
    setState(()=> loading = true);
    final result = await EditProfileDataHandler.getUserInfo();
    result.fold(
      (l)=> ToastHelper.showError(message: l.message),
      (r)=> userModel = r
    );
    if(result.isRight()) fillData();
    setState(()=> loading = false);
  }

  void resetData(){
    loading = false;
    autoValidate = false;
    phoneCountryCode = "+20";
    personalImage = null;
    birthday = null;
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    birthDateController.clear();
    phoneNumController.clear();
  }

  void fillData(){
    if(userModel == null) return;
    firstNameController.text = userModel!.firstName ?? "";
    lastNameController.text = userModel!.lastName ?? "";
    emailController.text = userModel!.email ?? "";
    phoneNumController.text = userModel!.phoneNumber ?? "";
    phoneCountryCode = userModel!.countryCode ?? phoneCountryCode;
    birthDateController.text = userModel!.birthDate == null? "" : FormatDateHelper.formatDate.format(userModel!.birthDate!);
    birthday = userModel!.birthDate;
  }

  Future onPickImage() async {
    File? pickImage = await PickMediaHelper.pickImage(context: currentContext_!);
    if (pickImage != null) {
      personalImage = pickImage;
      setState(() {});
    }
  }

  Future onPickBirthday() async {
    DialogHelper.custom(context: currentContext_!).customDialog(
      dialogWidget: CustomCalenderWidget(
        firstDay: DateTime.now().subtract(Duration(days: (365.25*100).toInt())),
        lastDay: DateTime.now(),
        focusDay: birthday,
        onSelectDay: (_){
          birthday = _;
          birthDateController.text = FormatDateHelper.formatDate.format(birthday!);
          setState(() {});
        },
      ),
    );
  }

  Future updateProfile()async{
    setState(()=> loading = true);
    final result = await EditProfileDataHandler.updateProfileData(
      userModel: UserModel(
        photoUrl: personalImage?.path,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumController.text,
        birthDate: birthday
      )
    );
    setState(()=> loading = false);
    result.fold(
      (l) => ToastHelper.showError(message: l.message),
      (r){
        ToastHelper.showSuccess(message: Strings.dataChangedSuccessfully.tr);
        resetData();
        userModel = r;
        fillData();
      },
    );
  }
}
