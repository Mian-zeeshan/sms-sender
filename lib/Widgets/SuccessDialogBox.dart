import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_sender/Controllers/ThemeController.dart';
import 'package:sms_sender/Model/PhoneNumbertModel.dart';
class SuccessDialog extends StatelessWidget {
  final List<PhoneNumberModel> phoneNumbers;

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
                const SizedBox(height: 5),
                const Divider(thickness: 1),
               Expanded(child: SingleChildScrollView(
                 child: Column(children: [
                             for(int i = 0 ; i< phoneNumbers.length; i++)    Padding(
                               padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                               child: Row(
                                children: [
                                  Icon(Icons.phone_outlined,color: theme.textColor.withOpacity(0.5),size: 20,),
                                  const SizedBox(width: 5,),
                                  Text(
                                    phoneNumbers[i].phone ?? '',
                                    style: TextStyle(
                                        color: theme.textColor),
                                  ),
                                  const SizedBox(width: 5),
                                    Text(
                                   "(${ phoneNumbers[i].name ?? ''})",
                                    style: TextStyle(
                                        color: theme.textColor.withOpacity(0.5)),
                                  ),
                                ],
                                                           ),
                             ),
                 ],),
               )),
                const Divider(thickness: 1),
                // const SizedBox(height: 5),
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