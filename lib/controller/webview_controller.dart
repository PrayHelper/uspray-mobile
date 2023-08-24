import 'package:com.prayhelper.uspray/controller/sharing_controller.dart';
import 'package:com.prayhelper.uspray/controller/token_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../debug/logger.dart';

class WebviewMainController extends GetxController {
  static WebviewMainController get to => Get.find();

  static var controller = WebViewController()
    ..enableZoom(false)
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) async{
          //TODO 특정 url을 따른 로직을 핸들링할 수 있음
          return NavigationDecision.navigate;
        },
      ),
    )
    //JavaScriptChannel을 웹뷰 컨트롤러에 더한다
    ..addJavaScriptChannel(
        //JavaScriptChannel 이름
        "FlutterGetDeviceToken",
        onMessageReceived: (JavaScriptMessage message) async {
          String fcmToken = await getFcmToken();
          sendDeviceToken(fcmToken);
        },
    )
    ..addJavaScriptChannel(
        "FlutterGetAuthToken",
        onMessageReceived: (JavaScriptMessage message) async {
          String refreshToken = await getRefreshToken();
          sendAuthToken(refreshToken);
        },
    )
    ..addJavaScriptChannel(
        "FlutterStoreAuthToken",
        onMessageReceived: (JavaScriptMessage message) async {
          storeRefreshToken(message.message);
        },
    )
    //TODO Sharing 채널명 정해야함
    ..addJavaScriptChannel(
        "NameForSharing",
        onMessageReceived: (JavaScriptMessage message) async {
          shareLinkForAOS(message.message);
        },
    )

    ..loadRequest(Uri.parse('https://www.dev.uspray.kr/'));

  WebViewController getController() {
    return controller;
  }

  static void sendDeviceToken(String token){
    logger.d("리액트 송신 완료 - $token}");
    controller.runJavaScript("window.onReceiveDeviceToken(\"$token\");");
  }
  static void sendAuthToken(String? token){
    logger.d("리액트 송신 완료");
    controller.runJavaScript("window.onReceiveAuthToken(\"$token\");");
  }
  // static void receiveAuthToken(){
  //   controller.runJavaScript("window.onReceiveTokenStoredMsg();");
  // }

  void loadUrl(String url) {
    controller.loadRequest(Uri.parse(url));
  }

}


