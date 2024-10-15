import 'dart:math';

import 'package:get/get.dart';


class LoginApis extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 60);
    httpClient.maxAuthRetries = 5;
    super.onInit();
  }

  Future<Response> getPhoneNumbers({soft,code,login,pass,type,msg}) {
    httpClient.timeout = const Duration(seconds: 60);
    httpClient.maxAuthRetries = 5;
    return get("https://itlyne.com/zapi.php?soft=$soft&code=$code&login=$login&pass=$pass&type=$type&msg=${msg}",
      );
  }

 

  
}
