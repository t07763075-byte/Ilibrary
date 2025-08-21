import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../Widgets/custom_network_image.dart';
import '../../../../generated/assets.dart';

class EditPhotoProfileWidget extends StatelessWidget {
  final File? selectedImage;
  final String? photoUrl;
  final Function() onPickImage;
  const EditPhotoProfileWidget({super.key, this.selectedImage, required this.onPickImage, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SizedBox(
          width: 118.w,
          height: 118.w,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              if(photoUrl != null && selectedImage == null) CustomNetworkImage(url: photoUrl, width: 100.r, height: 100.r,radius: 100.r,),
              if(selectedImage!= null) Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: FileImage(selectedImage!),fit: BoxFit.fill),
                ),
              ),
             if(selectedImage == null && photoUrl == null) Center(child: SvgPicture.asset(Assets.imagesChangeUserProfile)),
              PositionedDirectional(
                bottom: 4.h,
                end: 12.w,
                child: InkWell(
                  onTap:onPickImage,
                  child: Container(
                    height: 25.r,
                    width: 25.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: ThemeClass.of(context).primaryColor,
                    ),
                    child: Center(child: Icon(Icons.edit,size: 16.r,color: ThemeClass.of(context).backGroundColor,)),
                  ),
                ),
              )
            ],
          )),
    );
  }

}


