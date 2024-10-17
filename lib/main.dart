import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sms_sender/Controllers/LoginController.dart';
import 'package:sms_sender/Controllers/ThemeController.dart';


import 'package:sms_sender/SmsScreen.dart';
import 'package:sms_sender/Utils/constants.dart';
import 'package:sms_sender/splash_page/SplashScreen.dart';



void main() async {
    WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  await GetStorage.init();

  //** Init Controllers

  Get.put(ThemeController());
  Get.put(LoginController());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
     
          GetMaterialApp(
            debugShowCheckedModeBanner: false,
            // title: appName.tr,
            transitionDuration: const Duration(milliseconds: 700),
            // translations: WorldLanguage(),
            // localizationsDelegates: const [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'AR'),
            ],
            locale: const Locale('en', 'US'),
            initialRoute: splashRoute,
            getPages: [

              GetPage(name: splashRoute , page: () => const SplashScreen(), transition: Transition.fadeIn),
             GetPage(name: homeRoute , page: () =>  SimSelectionScreen(), transition: Transition.downToUp),
       


            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            builder: (context, child) { 
              child = EasyLoading.init()(context, child);
             return child!;
            },
          );
      
    
  }
}