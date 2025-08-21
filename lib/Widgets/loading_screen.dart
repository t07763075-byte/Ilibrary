import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Utilities/theme_helper.dart';

class LoadingScreen extends StatelessWidget {
  final Widget child;
  final bool loading;
  final Function()? onRefresh;
  const LoadingScreen({Key? key, required this.child,this.loading = false, this.onRefresh,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          if(loading) Positioned.fill(
            child: Container(
              color: ThemeClass.of(context).backGroundColor.withOpacity(.2),
            ),
          ),
          if(loading) Positioned(
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child:  SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:  ThemeClass.of(context).primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
