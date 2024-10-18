import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:sms_sender/Controllers/ThemeController.dart';

class SpinLoader extends StatefulWidget {
  const SpinLoader({super.key});

  @override
  SpinLoaderState createState() => SpinLoaderState();
}

class SpinLoaderState extends State<SpinLoader> {
  ThemeController theme = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: theme.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h,),
          SpinKitWave(color: theme.primaryColor, size: 30.w,),
          SizedBox(height: 20.h,),
          // Image.asset("assets/images/logo/logo.png", width: 100.w,),
        ],
      ),

    );
  }

}