import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayhelper/func/logger.dart';
import 'package:prayhelper/screen/web_view_screen.dart';
import 'package:prayhelper/screen/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'controller/webview_controller.dart';
import 'func/get_device_token.dart';

class PrayHelperApp extends StatelessWidget {
  PrayHelperApp({super.key});

  // 앱 정보 저장
  @override
  Widget build(BuildContext context) {
    final controller = WebviewMainController.to
        .getController();

    //TODO 몰라 어딘가에 배치해
    Future<String> _getUuid(BuildContext context) async {
      final String uuid = await controller
          .runJavaScriptReturningResult('document.getElementById("username").innerText') as String;
      return uuid;
    }


    return FutureBuilder<List<String>?>(

      future: Future.wait(
        [
          SplashDelay.waiting(),
          //Fetching WebPage
        ],
      ),
      builder: (context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                //테마설정
                primarySwatch: Colors.blue,
              ),
              home: SafeArea(
                child: WebViewScreen(controller: controller),)
          );
        } else {
          return const SplashScreen();
        }
      },
    );


  }
}