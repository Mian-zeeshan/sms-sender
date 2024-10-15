import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:sms_sender/Controllers/LoginController.dart';
class SmsSender {

  LoginController _loginController = Get.find();
  static const platform = MethodChannel('sms_sender');

  // Method to send SMS using the specified SIM slot (1 or 2)
  Future<void> sendSMS(String recipient, String message, int simSlot,BuildContext context) async {
    print("object");
    try {
      await platform.invokeMethod('sendSMS', {
        'recipient': recipient,
        'message': message,
        'simSlot': simSlot,  // Pass SIM slot as a parameter
      }).then((value) {

_loginController.updateList(recipient);


        //    ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(content: Text('$value successfully sent message')),
        //         );
        // print("sucess");
        // print(value); 
      },);
    } on PlatformException catch (e) {
      log("Failed to send SMS jnjknedjk : ${e.message}");
    }
  }
}