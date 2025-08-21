import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/Widgets/custom_textfield_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';

import '../../../Utilities/strings.dart';
import '../../../Utilities/validate.dart';
import '../../../Widgets/phone_number_field_widget.dart';
import '../../../Widgets/custom_appbar_widget.dart';
import '../../../Widgets/custom_button_widget.dart';
import 'Widget/edit_photo_profile_widget.dart';
import 'edit_profile_controller.dart';
class EditProfileScreen extends StatefulWidget {
  static const routeName="EditProfile";
  const EditProfileScreen({super.key});

  @override
   createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends StateX<EditProfileScreen> {
  _EditProfileScreenState():super(controller: EditProfileController()){
    con=EditProfileController();
  }
  late EditProfileController con;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    con.init();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  CustomAppBarWidget.mainDetailsScreen(
        screenName: Strings.editProfile.tr,
        showFavorite: false,
      ),
      body:LoadingScreen(
        loading: con.loading,
        child: Form(
          key: _formKey,
          autovalidateMode: con.autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 16.h),
                children: [
                  EditPhotoProfileWidget(
                    photoUrl: con.userModel?.photoUrl,
                    selectedImage: con.personalImage,
                    onPickImage: con.onPickImage,
                  ),
                  Gap(24.h),
                  Text(Strings.firstName.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                  Gap(10.h),
                  CustomTextFieldWidget(
                    underLineBorder: true,
                    style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                    controller: con.firstNameController,
                    isDense: true,
                    insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                    validator:Validate.validateName,
                  ),
                  Gap(40.h),
                  Text(Strings.lastName.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                  Gap(10.h),
                  CustomTextFieldWidget(
                    underLineBorder: true,
                    style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                    controller: con.lastNameController,
                    isDense: true,
                    insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                    validator:Validate.validateName,
                  ),
                  Gap(40.h),
                  Text(Strings.email.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                  Gap(10.h),
                  CustomTextFieldWidget(
                    enable: false,
                    underLineBorder: true,
                    style: TextStyleHelper.of(context).s20SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).darkGreyColor),
                    controller: con.emailController,
                    textInputType: TextInputType.emailAddress,
                    isDense: true,
                    insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                  ),
                  Gap(40.h),
                  Text(Strings.phoneNumber.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                  Gap(10.h),
                  CustomTextFieldWidget(
                    enable: false,
                    textInputType: TextInputType.phone,
                    prefixIcon: PhoneNumberFieldWidget(
                      initCountryDialCode: con.phoneCountryCode,
                      onCountryCodeChange: (_)=> con.phoneCountryCode = _.dialCode ?? "",
                    ),
                    underLineBorder: true,
                    style: TextStyleHelper.of(context).s20SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).darkGreyColor),
                    controller: con.phoneNumController,
                    isDense: true,
                    insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                  ),
                  Gap(40.h),
                  Text(Strings.dateOfBirth.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                  Gap(10.h),
                  InkWell(
                    onTap: con.onPickBirthday,
                    child: CustomTextFieldWidget(
                      underLineBorder: true,
                      style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                      isDense: true,
                      textInputType: TextInputType.phone,
                      insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                      enable: false,
                      controller: con.birthDateController,
                      onTap: con.onPickBirthday,
                      suffixIcon: SvgPicture.asset(Assets.imagesCalendarIc),
                    ),
                  ),
                  Gap(100.h),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                      color: ThemeClass.of(context).backGroundColor,
                    border: Border(top: BorderSide(
                      color: ThemeClass.of(context).alertBackground,
                      width: 1.r,
                    ),)
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomButtonWidget.secondary(
                              title: Strings.cancel.tr,
                              onTap:context.pop,
                            ),
                          ),
                          Gap(16.w),
                          Expanded(
                            child: CustomButtonWidget.customPrimary(
                              backgroundColor: con.isSomethingChange ? ThemeClass.of(context).primaryColor: const Color(0xffC67600),
                              onTap:() {
                                if(!con.isSomethingChange) return;
                                if (_formKey.currentState?.validate() ?? false) {
                                  con.updateProfile();
                                } else {
                                  setState(() {
                                    con.autoValidate = true;
                                  });
                                }
                              },
                              child: Text(Strings.saveChanges.tr,style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
