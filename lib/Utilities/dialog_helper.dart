import 'package:ELibrary/Utilities/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogHelper{
  final BuildContext context;
  final String? message;
  final String? title;

  DialogHelper({required this.context, this.message, this.title});

  factory DialogHelper.custom({required BuildContext context}){
    return DialogHelper(context: context);
  }

  Future successDialog() async {}
  Future deleteDialog({required warningMessage,required Function() confirmDelete,Function()? cancel}) async{}
  Future editDialog() async{}
  Future errorDialog({Function()? onTapOk,}) async{}


  void customDialog({required Widget dialogWidget,bool dismiss = true,double?radius,Color?backgroundColor,EdgeInsets?insetPadding,Function()? onDismiss}){
    showGeneralDialog(
      useRootNavigator: true,
      barrierLabel: "",
      context: context,
      barrierDismissible: dismiss,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(

          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius??40.r)),
          backgroundColor:backgroundColor?? ThemeClass.of(context).backGroundColor,
          insetPadding:insetPadding?? EdgeInsets.symmetric(horizontal: 24.w,vertical: 24.h),
          child: dialogWidget,
        );
      },
    ).then((_) {
      onDismiss?.call();
    });
  }

  Future customDialogPosition({required Widget dialogWidget,double? start,double? top,double? end,double? bottom,
    bool dismiss = true,Function()? onDismiss,Color? barrierColor})async{
    await showDialog(
      context: context,
      useRootNavigator: true,
      barrierLabel: "",
      barrierDismissible: dismiss,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              const SizedBox(width: double.infinity,height: double.infinity,),
              PositionedDirectional(
                start: start??0,
                top: top,
                end: end??0,
                bottom: bottom,
                child: Center(child: dialogWidget),
              )
            ],
          ),
        );
      },
    ).then((_) {
      onDismiss?.call();
    });
  }
}
