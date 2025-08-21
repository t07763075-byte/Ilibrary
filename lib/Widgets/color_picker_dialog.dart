import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_button_widget.dart';


class ColorPickerDialog extends StatelessWidget {
  final Color pickedColor;
  final void Function(Color) onColorChanged;
  const ColorPickerDialog({super.key, required this.pickedColor, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h,),
          HueRingPicker(
            pickerColor: pickedColor,
            colorPickerHeight: 200.h,
            portraitOnly: true,

            pickerAreaBorderRadius: BorderRadius.circular(20.r),
            onColorChanged: onColorChanged,
          ),
        SizedBox(height: 16.h,),
          CustomButtonWidget.primary(
            width: 150.w,
            height: 56.h,
            radius: 16.r,
            onTap: (){
              Navigator.of(context).pop();
              onColorChanged(pickedColor);
            },
            title: "save",
          ),
      ],
    );
  }
}