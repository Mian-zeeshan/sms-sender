import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_sender/Controllers/ThemeController.dart';
class SuccessDialog extends StatelessWidget {
  final List<String> phoneNumbers;

  SuccessDialog({required this.phoneNumbers});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      id: "0",
      builder: (theme) {
        return AlertDialog(
          
          backgroundColor:theme.whiteColor ,

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
          contentPadding: EdgeInsets.zero,
          elevation: 2,
          content: Container(
            width: Get.width,
            height: 500,
            child: Column(
              
              // mainAxisSize: MainAxisSize.max,
            
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const Text(
                  'Messages Sent!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
               Expanded(child: SingleChildScrollView(
                 child: Column(children: [
                             for(int i = 0 ; i< phoneNumbers.length; i++)    ListTile(
                          leading: const Icon(Icons.phone, color: Colors.green),
                          title: Text(phoneNumbers[i]),
                        )
                 ],),
               )),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}