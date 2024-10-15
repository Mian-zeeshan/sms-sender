
import 'package:get/get.dart';
import 'package:sms_sender/Model/PhoneNumbertModel.dart';
import 'package:sms_sender/Services/api.dart';
import 'dart:developer';
class LoginController extends GetxController{

  List<String> sendMessagePhoneList=[];

  updateList(value){
    sendMessagePhoneList.add(value);
    update(['0']);
    notifyChildrens();
  }
  clearList(){
    sendMessagePhoneList.clear();
    update(['0']);
    notifyChildrens();
  }
  LoginApis apis=LoginApis();
// List<PhoneNumberModel> phoneNumbers=[];
 Future<List<PhoneNumberModel>>  login({soft,code,login,pass,type,msg}) async {
  List<PhoneNumberModel> phoneNumbers=[];
  var val = await apis.getPhoneNumbers(code:code,login: login,msg: msg,pass: pass,soft: soft,type: type, );
  log("api response here ${val.body}");
  if (val.statusCode == 200) {
    // Parse the response into a list of PhoneNumberModel
    List<dynamic> data = val.body;

    // Map the data to a list of PhoneNumberModel
    phoneNumbers = data.map((item) => PhoneNumberModel.fromJson(item)).toList();

    // You now have a list of PhoneNumberModel objects
  
  } else {
    // Handle the error
    print("Error: ${val.statusText}");
  }

  return phoneNumbers;
}


}