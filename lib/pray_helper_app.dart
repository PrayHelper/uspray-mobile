import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayhelper/func/logger.dart';
import 'package:prayhelper/screen/web_view_screen.dart';
import 'package:prayhelper/screen/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'controller/webview_controller.dart';
import 'func/get_device_token.dart';
import 'main.dart';

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
          getFcmToken()
          //Fetching WebPage
        ],
      ),
      builder: (context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.hasData) {

          logger.d(snapshot.data![1]);

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var androidNotiDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
      );
      var iOSNotiDetails = const DarwinNotificationDetails();
      var details =
      NotificationDetails(android: androidNotiDetails, iOS: iOSNotiDetails);
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          details,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
    });
  }

}