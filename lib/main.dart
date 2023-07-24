import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayhelper/pray_helper_app.dart';
import 'controller/notification.dart';
import 'controller/notification_controller.dart';
import 'controller/webview_controller.dart';
import 'package:firebase_core/firebase_core.dart';

import 'func/logger.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;



void main() async {
  Get.put(WebviewMainController());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //추가
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  logger.d('User granted permission: ${settings.authorizationStatus}');

  //앱단위가 아니라 main에서 정의하는 메시지 핸들링
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      logger.d("여기가 Local Notification 영역");
    }
  });


  runApp(PrayHelperApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logger.d("Handling a background message: ${message.messageId}");
  showNotification();
}


