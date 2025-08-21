import 'package:ELibrary/Utilities/generic_file.dart';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Widgets/custom_appbar_widget.dart';
import 'package:ELibrary/Widgets/loading_screen.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:ELibrary/generated/assets.dart';
import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:state_extended/state_extended.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Utilities/enum.dart';
import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Utilities/validate.dart';
import '../../../../Widgets/custom_button_widget.dart';
import '../../../../Widgets/custom_dropdown_widget.dart';
import '../../../../Widgets/custom_textfield_widget.dart';
import '../help_center_controller.dart';

class ContactSupportScreen extends StatefulWidget {
  static const routeName = "ContactSupportScreen";

  const ContactSupportScreen({super.key});

  @override
  createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends StateX<ContactSupportScreen> {
  _ContactSupportScreenState() : super(controller: HelpCenterController()) {
    con = HelpCenterController();
  }

  late HelpCenterController con;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.detailsScreen(screenName: Strings.contactSupport.tr,),
      body: LoadingScreen(
        loading: con.loading,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Form(
            key: _formKey,
            autovalidateMode: con.autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: Strings.issueType.tr,
                    style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
                          color: ThemeClass.of(context).warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16.h),
                CustomDropDownWidget<ContactIssueType>(
                  items: ContactIssueType.values.map((e)=> DropdownMenuItem<ContactIssueType>(value: e,child: Text(e.name.tr),)).toList(),
                  selected: con.selectedIssueType,
                  underLineBorder: true,
                  style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                  hint: Strings.selectIssue.tr,
                  validate: Validate.validateDropDown,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  onChange: (_)=> con.selectedIssueType = _,
                ),
                Gap(40.h),
                RichText(
                  text: TextSpan(
                    text: Strings.subject.tr,
                    style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
                          color: ThemeClass.of(context).warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16.h),
                CustomTextFieldWidget(
                  underLineBorder: true,
                  style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                  controller: con.subjectController,
                  textInputType: TextInputType.emailAddress,
                  isDense: true,
                  hint: Strings.subject.tr,
                  insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                  validator: Validate.validateNormalString,
                ),
                Gap(40.h),
                RichText(
                  text: TextSpan(
                    text: Strings.description.tr,
                    style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
                          color: ThemeClass.of(context).warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16.h),
                CustomTextFieldWidget(
                  underLineBorder: true,
                  style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                  controller: con.descriptionController,
                  textInputType: TextInputType.emailAddress,
                  isDense: true,
                  hint: Strings.typeDescription.tr,
                  insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                  validator: Validate.validateNormalString,
                ),
                Gap(40.h),
                RichText(
                  text: TextSpan(
                    text: Strings.email.tr,
                    style: TextStyleHelper.of(context).s16SemiBoldTextStyle,
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyleHelper.of(context).s16SemiBoldTextStyle.copyWith(
                          color: ThemeClass.of(context).warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16.h),
                CustomTextFieldWidget(
                  underLineBorder: true,
                  style: TextStyleHelper.of(context).s20SemiBoldTextStyle,
                  controller: con.emailController,
                  textInputType: TextInputType.emailAddress,
                  isDense: true,
                  hint: Strings.typeEmail.tr,
                  insidePadding: EdgeInsets.symmetric(vertical: 8.h),
                  validator: Validate.validateEmail,
                ),
                Gap(40.h),
                Text(Strings.uploadFiles.tr, style: TextStyleHelper.of(context).s16SemiBoldTextStyle,),
                Gap(16.h),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(8.r), // Rounded corners
                  dashPattern: [3.r, 3.r], // Dot pattern
                  color: ThemeClass.of(context).primaryColor,
                  strokeWidth: 1.2.r,
                  child: SizedBox(
                    height: 56.h,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(Assets.imagesUpload,width: 26.r,height: 26.r,),
                        Gap(4.w),
                        RichText(
                          text: TextSpan(
                            text: Strings.dragAndDropFiles.tr,
                            style: TextStyleHelper.of(context).s12SemiBoldTextStyle.copyWith(
                              color: ThemeClass.of(context).darkGreyColor
                            ),
                            children: [
                              TextSpan(
                                text: Strings.chooseFile.tr,
                                style: TextStyleHelper.of(context).s12SemiBoldTextStyle.copyWith(
                                  color: ThemeClass.of(context).primaryColor,
                                ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = con.pickFile
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Strings.filesSupported.tr, style: TextStyleHelper.of(context).s8SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),),
                    Text(Strings.maximumSize.tr, style: TextStyleHelper.of(context).s8SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor),),
                  ],
                ),
                Gap(12.h),
                ...con.files.mapIndexed((index,file){
                  return FileWidget(
                    file: file,
                    onRemove: ()=> setState(()=> con.files.removeAt(index)),
                  );
                }).toList(),
                Gap(32.h),
                RichText(
                  text: TextSpan(
                    text: Strings.stillNeedSupport.tr,
                    style: TextStyleHelper.of(context).s14SemiBoldTextStyle,
                    children: [
                      TextSpan(
                        text: " Support@grandmstg.com",
                        style: TextStyleHelper.of(context).s14SemiBoldTextStyle.copyWith(color: ThemeClass.of(context).primaryColor,),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'Support@grandmstg.com',
                            );
                            launchUrl(emailLaunchUri);
                          },
                      ),
                    ],
                  ),
                ),
                Gap(24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButtonWidget.secondary(
                      height: 56.h,
                      width: 185.w,
                      title: Strings.cancel.tr,
                      onTap: ()=> context.pop(),
                    ),
                    CustomButtonWidget.primary(
                      height: 56.h,
                      width: 185.w,
                      title: Strings.submit.tr,
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          con.onSubmitContact();
                        }else{
                          setState(() {
                            con.autoValidate = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Gap(24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class FileWidget extends StatelessWidget {
  final GenericFile file;
  final Function() onRemove;
  const FileWidget({super.key, required this.file, required this.onRemove});

  Widget getExtensionLogo(){
    if(file.extension?.toLowerCase() == "pdf") return SvgPicture.asset(Assets.filesLogoPdf);
    if(file.fileType == PickedFileType.image) return SvgPicture.asset(Assets.filesLogoImageExtension);
    if(file.fileType == PickedFileType.document) return SvgPicture.asset(Assets.filesLogoDocumentExtension);
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeClass.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          getExtensionLogo(),
          Gap(8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(file.filename, style: TextStyleHelper.of(context).s10SemiBoldTextStyle,),
              Text(file.sizeAsString ?? "-", style: TextStyleHelper.of(context).s10RegTextStyle.copyWith(
                color: ThemeClass.of(context).lightGreyColor
              ),),
            ],
          ),
          const Spacer(),
          InkWell(onTap: onRemove,child: SvgPicture.asset(Assets.imagesDeleteIc,)),
        ],
      ),
    );
  }
}

