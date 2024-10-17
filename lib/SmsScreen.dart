import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sms_sender/Controllers/LoginController.dart';
import 'package:sms_sender/Controllers/ThemeController.dart';
import 'package:sms_sender/Model/PhoneNumbertModel.dart';
import 'package:sms_sender/SmsSender.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/Widgets/SuccessDialogBox.dart';

class SimSelectionScreen extends StatefulWidget {
  @override
  _SimSelectionScreenState createState() => _SimSelectionScreenState();
}

class _SimSelectionScreenState extends State<SimSelectionScreen> {
  final TextEditingController soft = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController login = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode softFocus = FocusNode();
  final FocusNode codeFocus = FocusNode();
  final FocusNode loginFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final FocusNode typeFocus = FocusNode();
  final FocusNode messageFocus = FocusNode();
  LoginController _loginController = Get.find();
  String? _selectedSim = 'SIM 1'; // Default selection
  final List<String> _simOptions = ['SIM 1', 'SIM 2'];
  int simCard = 0;
  void unfocusAllFields() {
    softFocus.unfocus();
    codeFocus.unfocus();
    loginFocus.unfocus();
    passFocus.unfocus();
    typeFocus.unfocus();
    messageFocus.unfocus();
  }

  Future<void> requestSmsPermissions() async {
    // Request SEND_SMS permission
    PermissionStatus sendSmsPermissionStatus = await Permission.sms.request();

    // Request READ_SMS permission
    PermissionStatus readSmsPermissionStatus = await Permission.sms.request();

    // Request READ_PHONE_STATE permission
    PermissionStatus readPhoneStatePermissionStatus =
        await Permission.phone.request();

    if (sendSmsPermissionStatus.isGranted &&
        readSmsPermissionStatus.isGranted &&
        readPhoneStatePermissionStatus.isGranted) {
      print("All SMS and Phone permissions granted");
      // You can now send and read SMS, or access phone state
    } else {
      print("One or more permissions denied");
      // Handle the case where one or more permissions are denied
    }
  }

  sendMessageUsingSim(
      int simSlot, String phn, PhoneNumberModel phoneNumber) async {
    String updatedMessage = _messageController.text
        .replaceAll("#NAME#", phoneNumber.name ?? "")
        .replaceAll("#AMT#", phoneNumber.amt ?? "");
    try {
      SmsSender smsSender = SmsSender();

      await smsSender
          .sendSMS(
              "${phn}", // The recipient's phone number
              updatedMessage,
              simSlot,
              context // Specify the SIM slot (1 or 2)
              )
          .then(
        (value) {
          // log(value.toString());
          // _phoneController.clear();
          // _messageController.clear();
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
 writeAppRunStatus() async {
  // Get a reference to the database
  DatabaseReference ref = FirebaseDatabase.instance.ref("appStatus");

  // Set the value of the 'isAppRun' field to true
  await ref.set({
    "isAppRun": true
  }).then((_) {
    print("Data added successfully!");
  }).catchError((error) {
    print("Failed to add data: $error");
  });
}
  @override
  void initState() {
    requestSmsPermissions();
    if (_loginController.loginModel.code != null) {
      soft.text = "${_loginController.loginModel.soft}";
      code.text = "${_loginController.loginModel.code}";
      login.text = "${_loginController.loginModel.login}";
      pass.text = "${_loginController.loginModel.pass}";
      type.text = "${_loginController.loginModel.type}";
      _selectedSim="${_loginController.loginModel.sim}";
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
        id: "0",
        builder: (theme) {
          return GetBuilder<LoginController>(
              id: "0",
              builder: (loginCntr) {
                return Scaffold(
                  backgroundColor: theme.backgroundColor,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: AppBar(
                      title: Text(
                        "Sms Sender",
                        style: TextStyle(color: theme.cardColor, fontSize: 25),
                      ),
                      elevation: 0,
                      backgroundColor: theme.primaryColor,
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  focusNode: softFocus,
                                  controller: soft,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.primaryColor)),
                                    // disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.redColor)),
                                    // focusColor: theme.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.textColor
                                                .withOpacity(0.2))),
                                    labelText: 'Software',
                                    labelStyle: TextStyle(
                                        color:
                                            theme.textColor.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: theme.primaryColor)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: codeFocus,
                                  controller: code,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.primaryColor)),
                                    // disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.redColor)),
                                    // focusColor: theme.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.textColor
                                                .withOpacity(0.2))),
                                    labelText: 'Code',
                                    labelStyle: TextStyle(
                                        color:
                                            theme.textColor.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: theme.primaryColor)),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  focusNode: loginFocus,
                                  controller: login,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.primaryColor)),
                                    // disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.redColor)),
                                    // focusColor: theme.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.textColor
                                                .withOpacity(0.2))),
                                    labelText: 'Login',
                                    labelStyle: TextStyle(
                                        color:
                                            theme.textColor.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: theme.primaryColor)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: passFocus,
                                  controller: pass,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.primaryColor)),
                                    // disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.redColor)),
                                    // focusColor: theme.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.textColor
                                                .withOpacity(0.2))),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        color:
                                            theme.textColor.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: theme.primaryColor)),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  focusNode: typeFocus,
                                  controller: type,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.primaryColor)),
                                    // disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.redColor)),
                                    // focusColor: theme.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.textColor
                                                .withOpacity(0.2))),
                                    labelText: 'Type',
                                    labelStyle: TextStyle(
                                        color:
                                            theme.textColor.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: theme.primaryColor)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedSim,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.primaryColor)),
                                    // disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.redColor)),
                                    // focusColor: theme.primaryColor,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: theme.textColor
                                                .withOpacity(0.2))),
                                    labelText: 'Select Sim',
                                    labelStyle: TextStyle(
                                        color:
                                            theme.textColor.withOpacity(0.5)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: theme.primaryColor)),
                                  ),
                                  items: _simOptions.map((String sim) {
                                    return DropdownMenuItem<String>(
                                      value: sim,
                                      child: Text(sim),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedSim = newValue;
                                      if (newValue?.toLowerCase().toString() ==
                                          "sim 1") {
                                        simCard = 0;
                                      } else if (newValue
                                              ?.toLowerCase()
                                              .toString() ==
                                          "sim 2") {
                                        simCard = 1;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _messageController,
                            focusNode: messageFocus,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 1.0, color: theme.primaryColor)),
                              // disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.redColor)),
                              // focusColor: theme.primaryColor,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 1.0,
                                      color: theme.textColor.withOpacity(0.2))),
                              labelText: 'Enter Message',
                              labelStyle: TextStyle(
                                  color: theme.textColor.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: theme.primaryColor)),
                            ),
                            maxLines: 5, // Allow multiple lines for the message
                          ),
                          SizedBox(height: 10),

                          const SizedBox(height: 20.0),

                          GestureDetector(
                            onTap:() async {
                              unfocusAllFields();

                              if (soft.text.isEmpty) {
                                EasyLoading.showToast('Soft field is required');
                                return; // Stop further execution if any field is empty
                              } else if (code.text.isEmpty) {
                                EasyLoading.showToast('Code field is required');
                                return;
                              } else if (login.text.isEmpty) {
                                EasyLoading.showToast(
                                    'Login field is required');
                                return;
                              } else if (pass.text.isEmpty) {
                                EasyLoading.showToast(
                                    'Password field is required');
                                return;
                              } else if (type.text.isEmpty) {
                                EasyLoading.showToast('Type field is required');
                                return;
                              } else if (_messageController.text.isEmpty) {
                                EasyLoading.showToast(
                                    'Message field is required');
                                return;
                              }
                              EasyLoading.show(status: "Loading...");

                              try {
                                List<PhoneNumberModel> phoneNumbers =
                                    await _loginController.login(
                                        code: code.text.toString(),
                                        login: login.text.toString(),
                                        msg: _messageController.text.toString(),
                                        pass: pass.text.toString(),
                                        soft: soft.text.toString(),
                                        type: type.text.toString(),
                                        sim: _selectedSim);

                                if (phoneNumbers.isNotEmpty) {
                                  await showPhoneNumbersDialog(
                                      context, phoneNumbers, loginCntr);
                                }
                              } catch (e) {
                                print(e.toString());
                              } finally {
                                EasyLoading.dismiss();
                              }

                              // sendMessageUsingSim(simCard);
                              // Clear the fields after sending
                            },
                            child: Container(
                              width: Get.width,
                              height: 45,
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: theme.whiteColor, fontSize: 17),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )
                          // ElevatedButton(
                          //   onPressed: () async {
                          //      EasyLoading.show(status: "Sending...");

                          // try{
                          //    List<PhoneNumberModel> phoneNumbers=   await _loginController.login();

                          //  if(phoneNumbers.isNotEmpty){
                          // await   showPhoneNumbersDialog(context,phoneNumbers);
                          //  }

                          // }
                          // catch(e){

                          //   print(e.toString());

                          // }
                          // finally{
                          //   EasyLoading.dismiss();
                          // }

                          //     // sendMessageUsingSim(simCard);
                          //     // Clear the fields after sending
                          //   },
                          //   child: const Text('Send Message'),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  showPhoneNumbersDialog(BuildContext context,
      List<PhoneNumberModel> phoneNumbers, LoginController loginCntr) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ThemeController>(
            id: "0",
            builder: (_theme) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: _theme.whiteColor,
                title: Text(
                  'Phone Number',
                  style: TextStyle(color: _theme.textColor, fontSize: 20),
                ),
                content: SizedBox(
                  // You can set a height if the list is large
                  height: 200.0,
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: phoneNumbers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  phoneNumbers[index].phone ?? '',
                                  style: TextStyle(
                                      color: _theme.textColor.withOpacity(0.5)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              height: 0.5,
                              color: _theme.textColor.withOpacity(0.3),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      _loginController.clearList();
                      EasyLoading.show(status: "Sending...");

                      try {
                        for (int i = 0; i < phoneNumbers.length; i++) {
                          await sendMessageUsingSim(simCard,
                              phoneNumbers[i].phone ?? "", phoneNumbers[i]);
                          print("dgjcvjhbdjs  " + i.toString());
                        }
                      } catch (e) {
                      } finally {
                        print(
                            "khdfbcjhbfhjdebcv dfvjkhbdfjhvbkjhfb ${loginCntr.sendMessagePhoneList.length}");
                        Navigator.of(context).pop();
                       if(loginCntr.sendMessagePhoneList.isNotEmpty) showSuccessDialog(
                            context, loginCntr.sendMessagePhoneList);
                        EasyLoading.dismiss();
                      }
                      // Handle send message logic here
                      print('Send Message');
                      // Close dialog
                    },
                    child: Text('Send Message'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      // Close dialog
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            });
      },
    );
  }

  void showSuccessDialog(BuildContext context, List<String> phoneNumbers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(phoneNumbers: phoneNumbers);
      },
    );
  }
}
