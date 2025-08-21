import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../splash_controller.dart';

class LargeSplashScreen extends StatefulWidget {
  const LargeSplashScreen({Key? key}) : super(key: key);

  @override
  State createState() => _LargeSplashScreenState();
}

class _LargeSplashScreenState extends State<LargeSplashScreen> {

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