import 'package:flutter/services.dart';

class SmsSender {
  static const platform = MethodChannel('sms_sender');

  // Method to send SMS using the specified SIM slot (1 or 2)
  Future<void> sendSMS(String recipient, String message, int simSlot) async {
    try {
      await platform.invokeMethod('sendSMS', {
        'recipient': recipient,
        'message': message,
        'simSlot': simSlot,  // Pass SIM slot as a parameter
      });
    } on PlatformException catch (e) {
      print("Failed to send SMS: ${e.message}");
    }
  }
}