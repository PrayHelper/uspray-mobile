import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({super.key, required this.controller});

  final WebViewController controller;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: WillPopScope(
            child: WebViewWidget(
              controller: widget.controller,
            ),
            onWillPop: () {
              return onGoBack();
            }),
      ),
    );
  }

  //TODO 이후 나가는 창 커스터마이징
  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('앱을 종료하시겠습니까?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('아니오'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('종료'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> onGoBack() async {
    if (await widget.controller.canGoBack()) {
      widget.controller.goBack();
      return Future.value(false);
    } else {
      Future<bool> dialogResult = showExitPopup();
      return Future.value(dialogResult);
    }
  }
}
