import 'dart:io';
import 'package:ELibrary/Utilities/strings.dart';
import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:ELibrary/core/Language/locales.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class PickMediaHelper {

  static Future<bool?> _getImageSource(BuildContext context) async {
    bool? isGallery;
    await showCupertinoModalPopup(
        context: context,
        barrierDismissible: true,
        useRootNavigator: true,
        builder: (context) {
          return CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Brightness.dark,
              primaryContrastingColor: ThemeClass.of(context).primaryColor,
              scaffoldBackgroundColor: ThemeClass.of(context).primaryColor,
              barBackgroundColor: ThemeClass.of(context).primaryColor,
              primaryColor: ThemeClass.of(context).primaryColor
            ),
            child: Theme(
              data: ThemeData.dark(),
              child: CupertinoAlertDialog(
                title: Container(
                  padding: EdgeInsets.all(10.r),
                  child: Text(Strings.chooseImageSource.tr,
                      style: TextStyleHelper.of(context).s18SemiBoldTextStyle),
                ),
                actions: [
                  Material(
                      child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      isGallery = true;
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                        child: Text(
                          Strings.fromGallery.tr,
                          style: TextStyleHelper.of(context).s18SemiBoldTextStyle,
                        )),
                  )),
                  Material(
                      // color: Colors.grey.shade200,
                      child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      isGallery = false;
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                        child: Text(
                          Strings.fromCamera.tr,
                          style: TextStyleHelper.of(context).s18SemiBoldTextStyle,
                        )),
                  )),
                ],
              ),
            ),
          );
        },

    );
    return isGallery;
  }

  static Future<File?> pickImage({required BuildContext context}) async {
    bool? isGallery = await PickMediaHelper._getImageSource(context);
    if (isGallery == null) return null;

    if(isGallery){
      final image = await FilePicker.platform.pickFiles(type: FileType.image);
      if(image?.files.firstOrNull?.path == null) return null;
      return File(image!.files.first.path!);
    }else{
      final XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
      if (file != null) return File(file.path);
      return null;
    }
  }



  static Future<List<File>> pickImages({required BuildContext context}) async {
    final List<XFile> files =
        await ImagePicker().pickMultiImage(imageQuality: 75);
    return files.map((e) => File(e.path)).toList();
  }

  static Future<File?> pickMedia({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickMedia();
    if (media != null) return File(media.path);
    return null;
  }

}
