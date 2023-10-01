import 'dart:convert';

import 'package:com.prayhelper.uspray/controller/sharing_controller.dart';
import 'package:com.prayhelper.uspray/controller/token_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../debug/logger.dart';

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
        onNavigationRequest: (NavigationRequest request) async {
          //TODO 특정 url을 따른 로직을 핸들링할 수 있음
          logger.d("PAGE FINISHED:: ${request.url}");
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
        await storeRefreshToken(message.message);
        sendAuthToken(message.message);
      },
    )
    ..addJavaScriptChannel(
      "FlutterShareLink",
      onMessageReceived: (JavaScriptMessage message) async {
        logger.d("SHARED IS CONNECTED");
        Map<String, dynamic> data = jsonDecode(message.message);
        shareLinkForAOS(data['url']);
      },
    )
    ..loadRequest(Uri.parse('https://www.dev.uspray.kr/'));

  WebViewController getController() {
    return controller;
  }

  static void sendDeviceToken(String token) {
    controller.runJavaScript("window.onReceiveDeviceToken(\"$token\");");
  }

  static void sendAuthToken(String? token) {
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
