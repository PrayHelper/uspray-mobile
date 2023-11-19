import 'dart:convert';

import 'package:com.prayhelper.uspray/controller/sharing_controller.dart';
import 'package:com.prayhelper.uspray/controller/token_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../logger.dart';

class WebviewMainController extends GetxController {
  static WebviewMainController get to => Get.find();

  static var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) async{
          if(request.url == "intent://plusfriend/chat/_UgxhYxj#Intent;scheme=kakaoplus;package=com.kakao.talk;end"){
            await _launchKakaoplusUrl();
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..enableZoom(false)
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
          await storeRefreshToken(message.message);
          sendAuthToken(message.message);
        },
    )
    ..addJavaScriptChannel(
        "FlutterShareLink",
        onMessageReceived: (JavaScriptMessage message) async {
          Map<String, dynamic> data = jsonDecode(message.message);
          shareLinkForAOS(data['url']);
        },
    )
    ..loadRequest(Uri.parse('https://www.dev.uspray.kr/'));

  WebViewController getController() {
    return controller;
  }

  static void sendDeviceToken(String token){
    controller.runJavaScript("window.onReceiveDeviceToken(\"$token\");");
  }
  static void sendAuthToken(String? token){
    controller.runJavaScript("window.onReceiveAuthToken(\"$token\");");
  }

  void loadUrl(String url) {
    controller.loadRequest(Uri.parse(url));
  }

  void setPlatformSpecifics(WebViewController controller){
    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
        ..setTextZoom(100)
        ..enableZoom(false);
    } else if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController);
      // .allowsBackForwardNavigationGestures = true;
    }
  }


}

Future<void> _launchKakaoplusUrl() async {
  const kakaoLink = 'kakaoplus://plusfriend/home/_UgxhYxj';
  Uri kakaoUri = Uri.parse(kakaoLink);



  if (await canLaunchUrl(kakaoUri)) {
    logger.d("Can launch LINK : $kakaoLink");
    launchUrl(kakaoUri);
  }

}
