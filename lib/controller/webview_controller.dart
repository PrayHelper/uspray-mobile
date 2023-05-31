import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayhelper/func/get_device_token.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewMainController extends GetxController {
  static WebviewMainController get to => Get.find();

  static var controller = WebViewController()
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
        onMessageReceived: (JavaScriptMessage message) async {
          var data = jsonDecode(message.message);
          //TODO login 성공메시지 명시
          if(data.loginSuccess){
            //TODO sendDeviceToken 로직
            String token = await getDeviceToken();
            sendDeviceToken(token);
          }
        }
    )
    ..loadRequest(Uri.parse('https://www.dev.uspray.kr'));

  WebViewController getController() {
    return controller;
  }
  static void sendDeviceToken(String token){
    //TODO 리액트 JS 코드의 함수에 따라 JS 코드 완성하기
    controller.runJavaScript('window.getDeviceToken($token)');
  }

}


