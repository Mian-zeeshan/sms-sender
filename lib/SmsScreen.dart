import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:sms_sender/Controllers/LoginController.dart';
import 'package:sms_sender/Controllers/ThemeController.dart';
import 'package:sms_sender/Model/PhoneNumbertModel.dart';
import 'package:sms_sender/SmsSender.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/Utils/Utils.dart';
import 'package:sms_sender/Widgets/SuccessDialogBox.dart';
import 'package:sms_sender/webview_page/WebviewPage.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  Utils utils = Utils();
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
      // You can now send and read SMS, or access phone state
    } else {
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
              phoneNumber, // The recipient's phone number
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
    } catch (e) {}
  }

  writeAppRunStatus() async {
    // Get a reference to the database
    DatabaseReference ref = FirebaseDatabase.instance.ref("appStatus");

    // Set the value of the 'isAppRun' field to true
    await ref.set({"isAppRun": true}).then((_) {}).catchError((error) {});
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
      _selectedSim = "${_loginController.loginModel.sim}";

      simCard = _selectedSim == "SIM 1" ? 0 : 1;
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
                          const SizedBox(
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
                              const SizedBox(
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
                          const SizedBox(height: 10),
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
                              const SizedBox(
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
                          const SizedBox(height: 10),
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
                              const SizedBox(
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
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 10),
                          const SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () async {
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
                              } finally {
                                EasyLoading.dismiss();
                              }

                              // sendMessageUsingSim(simCard);
                              // Clear the fields after sending
                            },
                            child: Container(
                              width: Get.width,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: theme.whiteColor, fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: [
                              GestureDetector(
                                onTap: ()=>Get.to(()=>WebviewPage(title: "Today",
                                url: "https://itlyne.com/zapiurl.php?app=tdy&soft=${loginCntr.loginModel.soft}&code=${loginCntr.loginModel.code}&login=${loginCntr.loginModel.login}&pass=${loginCntr.loginModel.pass}",)),
                                child: Container(
                                    height: 35.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: theme.backgroundColor,
                                        border: Border.all(
                                            color: theme.primaryColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          TablerIcons.calendar_month,
                                          color: theme.textColor.withOpacity(0.5),
                                          size: 15.h,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          "Today",
                                          style: utils
                                              .xSmallLabelStyle(theme.textColor),
                                        )
                                      ],
                                    )),
                              ),
                              GestureDetector(
                                 onTap: ()=>Get.to(()=>WebviewPage(title: "Yesterday",
                           url: "https://itlyne.com/zapiurl.php?app=ystrdy&soft=${loginCntr.loginModel.soft}&code=${loginCntr.loginModel.code}&login=${loginCntr.loginModel.login}&pass=${loginCntr.loginModel.pass}",)),
                                child: Container(
                                    height: 35.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: theme.backgroundColor,
                                        border: Border.all(
                                            color: theme.primaryColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          TablerIcons.calendar_clock,
                                          color: theme.textColor.withOpacity(0.5),
                                          size: 15.h,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          "Yesterday",
                                          style: utils
                                              .xSmallLabelStyle(theme.textColor),
                                        )
                                      ],
                                    )),
                              ),
                              GestureDetector(
                                 onTap: ()=>Get.to(()=>WebviewPage(title: "This Month",
                          url: "https://itlyne.com/zapiurl.php?app=mnth&soft=${loginCntr.loginModel.soft}&code=${loginCntr.loginModel.code}&login=${loginCntr.loginModel.login}&pass=${loginCntr.loginModel.pass}",)),
                                child: Container(
                                    height: 35.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: theme.backgroundColor,
                                        border: Border.all(
                                            color: theme.primaryColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          TablerIcons.calendar_bolt,
                                          color: theme.textColor.withOpacity(0.5),
                                          size: 15.h,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          "This Month",
                                          style: utils
                                              .xSmallLabelStyle(theme.textColor),
                                        )
                                      ],
                                    )),
                              ),
                              GestureDetector(
                                 onTap: ()=>Get.to(()=>WebviewPage(title: "Last Month",
                            url: "https://itlyne.com/zapiurl.php?app=lstmnth&soft=${loginCntr.loginModel.soft}&code=${loginCntr.loginModel.code}&login=${loginCntr.loginModel.login}&pass=${loginCntr.loginModel.pass}",)),
                                child: Container(
                                    height: 35.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: theme.backgroundColor,
                                        border: Border.all(
                                            color: theme.primaryColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          TablerIcons.calendar,
                                          color: theme.textColor.withOpacity(0.5),
                                          size: 15.h,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          "Last Month",
                                          style: utils
                                              .xSmallLabelStyle(theme.textColor),
                                        )
                                      ],
                                    )),
                              ),
                              GestureDetector(
                                  onTap: ()=>Get.to(()=>WebviewPage(title: "Balance Sheet",
                                 url: "https://itlyne.com/zapiurl.php?app=blsht&soft=${loginCntr.loginModel.soft}&code=${loginCntr.loginModel.code}&login=${loginCntr.loginModel.login}&pass=${loginCntr.loginModel.pass}",)),
                               
                                child: Container(
                                    height: 35.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: theme.backgroundColor,
                                        border: Border.all(
                                            color: theme.primaryColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          TablerIcons.file_analytics,
                                          color: theme.textColor.withOpacity(0.5),
                                          size: 15.h,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          "Balance Sheet",
                                          style: utils
                                              .xSmallLabelStyle(theme.textColor),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          )
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
            builder: (theme) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: theme.whiteColor,
                title: Text(
                  'Phone Number',
                  style: utils.labelStyle(theme.textColor)
                ),
                content: SizedBox(
                  // You can set a height if the list is large
                  height: 220.0,
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
                                Icon(
                                  Icons.phone_outlined,
                                  color: theme.textColor.withOpacity(0.5),
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  phoneNumbers[index].phone ?? '',
                                  style: TextStyle(color: theme.textColor),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    "(${phoneNumbers[index].name ?? ''})",
                                    style: TextStyle(
                                        color:
                                            theme.textColor.withOpacity(0.5)),
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: Checkbox(
                                    value: phoneNumbers[index].isCheck,
                                    onChanged: (value) {
                                      if (phoneNumbers[index].isCheck) {
                                        phoneNumbers[index].isCheck = false;
                                      } else {
                                        phoneNumbers[index].isCheck = true;
                                      }
                                      theme.updateWidget();
                                    },
                                  ),
                                )
                              ],
                            ),
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
                          if (phoneNumbers[i].isCheck) {
                            await sendMessageUsingSim(simCard,
                                phoneNumbers[i].phone ?? "", phoneNumbers[i]);
                          }
                        }
                      } finally {
                        Navigator.of(context).pop();
                        if (loginCntr.sendMessagePhoneList.isNotEmpty) {
                          showSuccessDialog(
                              context, loginCntr.sendMessagePhoneList);
                        }
                        EasyLoading.dismiss();
                      }
                      // Handle send message logic here
                      // Close dialog
                    },
                    child: const Text('Send Message'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      // Close dialog
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            });
      },
    );
  }

  void showSuccessDialog(
      BuildContext context, List<PhoneNumberModel> phoneNumbers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(phoneNumbers: phoneNumbers);
      },
    );
  }
}
