import 'dart:convert';

import 'package:com.prayhelper.uspray/controller/sharing_controller.dart';
import 'package:com.prayhelper.uspray/controller/token_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


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
          if(request.url == "https://pf.kakao.com/_UgxhYxj"){
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
    ..loadRequest(Uri.parse('https://www.uspray.kr/'));

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
  Uri url = await TalkApi.instance.addChannelUrl("_UgxhYxj");
  try {
    await launchBrowserTab(url);
  } catch (e) {
    print("카톡 채널 추가 실패 에러 : $e");
  }
}
