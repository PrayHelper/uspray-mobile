import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenBefore extends StatefulWidget {
  WebViewScreenBefore({super.key, required this.controller});

  final WebViewController controller;

  @override
  State<WebViewScreenBefore> createState() => _WebViewScreenBeforeState();
}

class _WebViewScreenBeforeState extends State<WebViewScreenBefore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: WillPopScope(
        onWillPop: onGoBack,
            child: WebViewWidget(
              controller: widget.controller,
            ),
      ),
    ));
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
    if (await widget.controller.currentUrl() != 'https://www.dev.uspray.kr/main') {
      if(!await widget.controller.canGoBack()){
        Future<bool> dialogResult = showExitPopup();
        return Future.value(dialogResult);
      }else {
        widget.controller.goBack();
        return Future.value(false);
      }
    } else {
      Future<bool> dialogResult = showExitPopup();
      return Future.value(dialogResult);
    }
  }
}