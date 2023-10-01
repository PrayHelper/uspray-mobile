// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//
// import '../controller/sharing_controller.dart';
// import '../controller/token_controller.dart';
//
// class WebViewScreen extends StatefulWidget {
//   WebViewScreen({super.key});
//
//   late final WebViewController controller;
//
//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }
//
// class _WebViewScreenState extends State<WebViewScreen> {
//   @override
//   void initState() {
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams();
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     widget.controller = WebViewController.fromPlatformCreationParams(params);
//     widget.controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {},
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) async {
//             //TODO 특정 url을 따른 로직을 핸들링할 수 있음
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//     //JavaScriptChannel을 웹뷰 컨트롤러에 더한다
//       ..addJavaScriptChannel(
//         //JavaScriptChannel 이름
//         "FlutterGetDeviceToken",
//         onMessageReceived: (JavaScriptMessage message) async {
//           String fcmToken = await getFcmToken();
//           sendDeviceToken(fcmToken);
//         },
//       )..addJavaScriptChannel(
//       "FlutterGetAuthToken",
//       onMessageReceived: (JavaScriptMessage message) async {
//         String refreshToken = await getRefreshToken();
//         sendAuthToken(refreshToken);
//       },
//     )..addJavaScriptChannel(
//       "FlutterStoreAuthToken",
//       onMessageReceived: (JavaScriptMessage message) async {
//         await storeRefreshToken(message.message);
//         sendAuthToken(message.message);
//       },
//     )..addJavaScriptChannel(
//       "FlutterShareLink",
//       onMessageReceived: (JavaScriptMessage message) async {
//         Map<String, dynamic> data = jsonDecode(message.message);
//         shareLinkForAOS(data['url']);
//       },
//     )
//       ..loadRequest(Uri.parse('https://www.dev.uspray.kr/'));
//
//     if (widget.controller.platform is AndroidWebViewController) {
//       setAndroidController(widget.controller);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         child: WillPopScope(
//             child: WebViewWidget(
//               controller: widget.controller,
//             ),
//             onWillPop: () {
//               return onGoBack();
//             }),
//       ),
//     );
//   }
//
//   Future<bool> showExitPopup() async {
//     return await showDialog(
//       context: context,
//       builder: (context) =>
//           AlertDialog(
//             title: const Text(
//               '앱 종료', style: TextStyle(fontWeight: FontWeight.w600),),
//             content: const Text('앱에서 나가시겠습니까?'),
//             actions: [
//               Row(children: [
//                 Expanded(flex: 1, child: Container()),
//                 ElevatedButton(
//                     onPressed: () => Navigator.of(context).pop(false),
//                     child: const Text('아니오'),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                         Colors.green // Text Color (Foreground color)
//                     )),
//                 Expanded(flex: 3, child: Container()),
//                 ElevatedButton(
//                     onPressed: () => Navigator.of(context).pop(true),
//                     child: const Text('종료'),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                         Colors.green // Text Color (Foreground color)
//                     )),
//                 Expanded(flex: 1, child: Container()),
//               ]),
//               Container(height: 10,)
//             ],
//           ),
//     ) ??
//         false;
//   }
//
//   Future<bool> onGoBack() async {
//     //TODO URL CHANGE
//     if (await widget.controller.canGoBack() &&
//         await widget.controller.currentUrl() !=
//             'https://www.dev.uspray.kr/main') {
//       widget.controller.goBack();
//       return Future.value(false);
//     } else {
//       Future<bool> dialogResult = showExitPopup();
//       return Future.value(dialogResult);
//     }
//   }
//
//   void setAndroidController(WebViewController controller) {
//     (controller.platform as AndroidWebViewController)
//       ..setTextZoom(100);
//   }
//
//   WebViewController getController() {
//     return widget.controller;
//   }
//
//   void sendDeviceToken(String token) {
//     widget.controller.runJavaScript("window.onReceiveDeviceToken(\"$token\");");
//   }
//
//   void sendAuthToken(String? token) {
//     widget.controller.runJavaScript("window.onReceiveAuthToken(\"$token\");");
//   }
//
//   void loadUrl(String url) {
//     widget.controller.loadRequest(Uri.parse(url));
//   }
// }
