
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:sms_sender/Controllers/ThemeController.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sms_sender/Utils/constants.dart';
class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      timer.cancel();

      Get.offAllNamed(homeRoute);
  
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(id: "0",builder: (theme) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 2000)
        ..indicatorType = EasyLoadingIndicatorType.wave
        ..loadingStyle = EasyLoadingStyle.custom
        ..indicatorSize = 25.0
        ..radius = 10.0
        ..maskType = EasyLoadingMaskType.black
        ..progressColor = theme.textColor
        ..backgroundColor = theme.cardColor
        ..indicatorColor = theme.textColor.withOpacity(0.8)
        ..textColor = theme.textColor
        ..maskColor = theme.cardColor.withOpacity(0.3)
        ..textPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 45)
      
        ..userInteractions = false
        ..dismissOnTap = false;

      return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: theme.primaryColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: theme.primaryColor,
          child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                  color: theme.primaryColor
              ),
              child: Animate(
                delay: const Duration(milliseconds: 900),
                effects: const [FadeEffect(), ScaleEffect()],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(theme.theme == "0" ? "Assets/Images/logo1.png" : "Assets/Images/logo1.png" , height: 120,),
                    SizedBox(height: 20,),
                    SpinKitWave(color: theme.whiteColor, size: 50,)
                  ],
                ),
              )
          ),
        ),
      ),
    );
    });
  }

}