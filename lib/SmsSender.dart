import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:sms_sender/Controllers/LoginController.dart';
import 'package:sms_sender/Model/PhoneNumbertModel.dart';

class SmsSender {
  LoginController _loginController = Get.find();
  static const platform = MethodChannel('sms_sender');

  // Method to send SMS using the specified SIM slot (1 or 2)
  Future<void> sendSMS(PhoneNumberModel phoneNumber, String message, int simSlot,
      BuildContext context) async {
    print("object");
    try {
      await platform.invokeMethod('sendSMS', {
        'recipient': phoneNumber.phone,
        'message': message,
        'simSlot': simSlot, // Pass SIM slot as a parameter
      }).then(
        (value) {
          _loginController.updateList(phoneNumber);

          //    ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('$value successfully sent message')),
          //         );
          // print("sucess");
          // print(value);
        },
      );
    } on PlatformException catch (e) {
      // Get.snackbar("Error", e.message??"",duration: Duration(seconds: 3));
      log("Failed to send SMS jnjknedjk : ${e.message}");
    }
  }
}
