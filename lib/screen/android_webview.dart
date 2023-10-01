import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../controller/sharing_controller.dart';
import '../controller/token_controller.dart';

class AndroidWebView extends StatefulWidget {
  const AndroidWebView({super.key});

  @override
  State<AndroidWebView> createState() => _AndroidWebViewState();
}

class _AndroidWebViewState extends State<AndroidWebView> {
  late final PlatformWebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PlatformWebViewController(
      AndroidWebViewControllerCreationParams(),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setPlatformNavigationDelegate(
          PlatformNavigationDelegate(PlatformNavigationDelegateCreationParams())
            ..setOnProgress(
              (int progress) {},
            )
            ..setOnPageStarted(
              (String url) {},
            )
            ..setOnPageFinished(
              (String url) {},
            )
            ..setOnWebResourceError(
              (WebResourceError error) {},
            )
            ..setOnNavigationRequest(
              (NavigationRequest request) async {
                //TODO 특정 url을 따른 로직을 핸들링할 수 있음
                return NavigationDecision.navigate;
              },
            ))
      ..addJavaScriptChannel(JavaScriptChannelParams(
        name: "FlutterGetDeviceToken",
        onMessageReceived: (JavaScriptMessage message) async {
          String fcmToken = await getFcmToken();
          sendDeviceToken(fcmToken, _controller);
        },
      ))
      ..addJavaScriptChannel(JavaScriptChannelParams(
        name: "FlutterGetAuthToken",
        onMessageReceived: (JavaScriptMessage message) async {
          String refreshToken = await getRefreshToken();
          sendAuthToken(refreshToken, _controller);
        },
      ))
      ..addJavaScriptChannel(JavaScriptChannelParams(
        name: "FlutterStoreAuthToken",
        onMessageReceived: (JavaScriptMessage message) async {
          await storeRefreshToken(message.message);
          sendAuthToken(message.message, _controller);
        },
      ))
      ..addJavaScriptChannel(JavaScriptChannelParams(
        name: "FlutterShareLink",
        onMessageReceived: (JavaScriptMessage message) async {
          Map<String, dynamic> data = jsonDecode(message.message);
          shareLinkForAOS(data['url']);
        },
      ))
      ..loadRequest(
          LoadRequestParams(uri: Uri.parse('https://www.dev.uspray.kr/')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: WillPopScope(
            child: PlatformWebViewWidget(PlatformWebViewWidgetCreationParams(
                    controller: _controller))
                .build(context),
            onWillPop: () {
              return onGoBack();
            }),
      ),
    );
  }

  PlatformWebViewController getController() {
    return _controller;
  }

  void sendDeviceToken(String token, PlatformWebViewController controller) {
    controller.runJavaScript("window.onReceiveDeviceToken(\"$token\");");
  }

  static void sendAuthToken(
      String? token, PlatformWebViewController controller) {
    controller.runJavaScript("window.onReceiveAuthToken(\"$token\");");
  }

  void loadUrl(String url) {
    _controller.loadRequest(LoadRequestParams(uri: Uri.parse(url)));
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 종료', style: TextStyle(fontWeight: FontWeight.w600),),
        content: const Text('앱에서 나가시겠습니까?'),
        actions: [
          Row(children: [
            Expanded(flex:1, child: Container()),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('아니오'),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.green // Text Color (Foreground color)
                )),
            Expanded(flex:3,child: Container()),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('종료'),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.green // Text Color (Foreground color)
                )),
            Expanded(flex:1, child: Container()),
          ]),
          Container(height: 10,)
        ],
      ),
    ) ??
        false;
  }

  Future<bool> onGoBack() async {
    //TODO URL CHANGE
    if (await _controller.canGoBack() &&
        await _controller.currentUrl() !=
            'https://www.dev.uspray.kr/main') {
      _controller.goBack();
      return Future.value(false);
    } else {
      Future<bool> dialogResult = showExitPopup();
      return Future.value(dialogResult);
    }
  }
}
