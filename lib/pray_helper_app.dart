import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:prayhelper/controller/notification.dart';
import 'package:prayhelper/func/logger.dart';
import 'package:prayhelper/screen/web_view_screen.dart';
import 'package:prayhelper/screen/splash_screen.dart';
import 'controller/webview_controller.dart';
import 'func/get_device_token.dart';

class PrayHelperApp extends StatefulWidget {
  PrayHelperApp({super.key});

  @override
  State<PrayHelperApp> createState() => _PrayHelperAppState();
}

class _PrayHelperAppState extends State<PrayHelperApp> {

  // 앱 정보 저장
  @override
  Widget build(BuildContext context) {
    final controller = WebviewMainController.to
        .getController();

    return FutureBuilder<List<String>?>(

      future: Future.wait(
        [
          SplashDelay.waiting(),
          getFcmToken()
          //Fetching WebPage
        ],
      ),
      builder: (context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.hasData) {

          logger.d("<<"+snapshot.data![1]+">>");

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
  @override
  void initState() {
    super.initState();

  }

  // Future<void> setupInteractedMessage() async {
  //
  //   RemoteMessage? initialMessage =
  //   await FirebaseMessaging.instance.getInitialMessage();
  //
  //   if (initialMessage != null) {
  //     logger.d("WHAT!!!!!!!!!!!!!!!!!!!!!!!!!");
  //     _handleMessage(initialMessage);
  //   }
  //
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }
  // //TODO URL
  // void _handleMessage(RemoteMessage message) {
  //   logger.d("WHAT?????????????????????????????????????");
  //   //Handler
  // }

}