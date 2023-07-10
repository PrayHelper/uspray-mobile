import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prayhelper/func/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../func/get_device_token.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({super.key, required this.controller});

  final WebViewController controller;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d("웹뷰 빌드 성공");

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
    if (await widget.controller.canGoBack()) {
      widget.controller.goBack();
      return Future.value(false);
    } else {
      Future<bool> dialogResult = showExitPopup();
      return Future.value(dialogResult);
    }
  }
}
