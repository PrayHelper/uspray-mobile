import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewMainController extends GetxController {
  static WebviewMainController get to => Get.find();

  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) async{
          //TODO 특정 url을 따른 로직을 핸들링할 수 있음
          return NavigationDecision.navigate;
        },
      ),
    )
    ..addJavaScriptChannel(
        "LoginToaster",
        onMessageReceived: (JavaScriptMessage message){
          var data = jsonDecode(message.message);
          //TODO login 성공메시지 명시
          if(data == "login"){
            //TODO sendDeviceToken 로직
            // runJavaScript 구현
            // getDeviceToken() 사용
          }
        }
    )
    ..loadRequest(Uri.parse('https://www.dev.uspray.kr'));


  WebViewController getController() {
    return controller;
  }
}