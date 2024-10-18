import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:sms_sender/Controllers/ThemeController.dart';
import 'package:sms_sender/SpinLoader.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  final String title;
  const WebviewPage({super.key, required this.url, required this.title});

  @override
  WebviewPageState createState() => WebviewPageState();
}

class WebviewPageState extends State<WebviewPage> {

  //** Controllers
  late WebViewController controller;
  ThemeController theme = Get.find();
  bool isLoading = true;
  // ** Utils
  // Utils utils = Utils();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
           onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(
          color: theme.primaryColor,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Get.width,
                color: theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      Get.back();
                    }, icon: Icon(TablerIcons.arrow_left, color: theme.whiteColor,)),
                    Text(widget.title, style:TextStyle(fontSize: 25,color: theme.whiteColor,fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Expanded(child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  isLoading?

                  SpinLoader():Container()
                ],
              ))
            ],
        ),
        ),
      ),
    );
  }

}