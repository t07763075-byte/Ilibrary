import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../splash_controller.dart';

class MediumSplashScreen extends StatefulWidget {
  const MediumSplashScreen({Key? key}) : super(key: key);

  @override
  State createState() => _MediumSplashScreenState();
}

class _MediumSplashScreenState extends State<MediumSplashScreen> {

  final SplashController con = SplashController();


  @override
  void initState() {
    con.dependOnInheritedWidget(context);
    con.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("logo path", width: 240.r, height: 240.r,),
            SizedBox(height: 100.h,),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}