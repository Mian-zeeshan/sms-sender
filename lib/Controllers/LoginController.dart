import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:sms_sender/Model/LoginModel.dart';
import 'package:sms_sender/Model/PhoneNumbertModel.dart';
import 'package:sms_sender/Services/api.dart';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:sms_sender/Utils/constants.dart';

class LoginController extends GetxController {
  var box = GetStorage();
 bool isAppRun = true;
  void listenToAppRunStatus() {
  // Get a reference to the database
  DatabaseReference ref = FirebaseDatabase.instance.ref("appStatus");

  // Set up a listener for real-time updates
  ref.onValue.listen((DatabaseEvent event) {
    if (event.snapshot.exists) {
       isAppRun = event.snapshot.child("isAppRun").value as bool;
       if(isAppRun==false){
        Get.offAllNamed(splashRoute);
       }
      print("Real-time update: isAppRun is $isAppRun");
    } else {
      print("No data available");
    }
    update(['0']);
    notifyChildrens();
  });
}
   @override
  void onInit() {
    listenToAppRunStatus();
     getLoginModel();

    // TODO: implement onInit
    super.onInit();
  }

  getLoginModel() async {
    var val = await box.read("login");
    if (val != null) {
      loginModel = LoginModel.fromJson(jsonDecode(jsonEncode(val)));
    }
    update(['0']);
    notifyChildrens();
  }

  LoginModel loginModel = LoginModel();
  List<String> sendMessagePhoneList = [];

  updateList(value) {
    sendMessagePhoneList.add(value);
    update(['0']);
    notifyChildrens();
  }

  clearList() {
    sendMessagePhoneList.clear();
    update(['0']);
    notifyChildrens();
  }

  LoginApis apis = LoginApis();
// List<PhoneNumberModel> phoneNumbers=[];
  Future<List<PhoneNumberModel>> login(
      {soft, code, login, pass, type, msg,sim}) async {
    List<PhoneNumberModel> phoneNumbers = [];
    var val = await apis.getPhoneNumbers(
      code: code,
      login: login,
      msg: msg,
      pass: pass,
      soft: soft,
      type: type,
    );
    log("api response here ${val.body}");
    if (val.statusCode == 200) {
      loginModel = LoginModel(
          code: code,
          login: login,
          msg: msg,
          pass: pass,
          soft: soft,
          type: type,
          sim: sim);

      await box.write("login", loginModel.toJson());

      // Parse the response into a list of PhoneNumberModel
      List<dynamic> data = val.body;

      // Map the data to a list of PhoneNumberModel
      phoneNumbers =
          data.map((item) => PhoneNumberModel.fromJson(item)).toList();

      // You now have a list of PhoneNumberModel objects
    } else {
      // Handle the error
      print("Error: ${val.statusText}");
    }

    return phoneNumbers;
  }
}
