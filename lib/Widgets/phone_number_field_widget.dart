import 'package:ELibrary/Utilities/text_style_helper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utilities/theme_helper.dart';

class PhoneNumberFieldWidget extends StatefulWidget {
  final Function(CountryCode) onCountryCodeChange;
  final String initCountryDialCode;
  const PhoneNumberFieldWidget({super.key, required this.onCountryCodeChange, required this.initCountryDialCode});

  @override
  State<PhoneNumberFieldWidget> createState() => _PhoneNumberFieldWidgetState();
}

class _PhoneNumberFieldWidgetState extends State<PhoneNumberFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      initialSelection: widget.initCountryDialCode,
      backgroundColor: ThemeClass.of(context).backGroundColor,
      dialogBackgroundColor: ThemeClass.of(context).backGroundColor,
      onChanged: widget.onCountryCodeChange,
      favorite: const ["+20", "+966"],
      builder: (countryCode){
        if(countryCode == null) return const SizedBox();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(countryCode.flagUri != null) ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Image.asset(
                countryCode.flagUri!,
                package: 'country_code_picker',
                width: 24.w,
                height: 18.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 4.w,),
            RotatedBox(
              quarterTurns: 3,
              child: Icon(Icons.arrow_back_ios_new_outlined,color: ThemeClass.of(context).primaryColor,),
            ),
            SizedBox(width: 6.w,),
            Text(countryCode.dialCode ?? "",style: TextStyleHelper.of(context).s16RegTextStyle,),
            SizedBox(width: 6.w,),
          ],
        );
      },
    );
  }
}
