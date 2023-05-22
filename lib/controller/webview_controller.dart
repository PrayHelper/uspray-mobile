import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayhelper/func/get_device_token.dart';
import 'package:prayhelper/func/logger.dart';
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
          if(url.contains("signin-success")){

          }
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) async{
          if (request.url.contains("signin-success")) {
            //TODO: 이 부분을 request 요청을 보내는 것으로 대체
            logger.d(await getDeviceToken());
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://www.uspray.kr'));


  WebViewController getController() {
    return controller;
  }
}