import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:com.prayhelper.uspray/pray_helper_app.dart';
import 'controller/local_notification.dart';
import 'controller/fcm_setting.dart';
import 'controller/webview_controller.dart';
import 'package:firebase_core/firebase_core.dart';

late AndroidNotificationChannel channel;

void main() async {
  Get.put(WebviewMainController());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //FCM & local 알림 명시
  await notificationSetting();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  fcmSetting();

  runApp(PrayHelperApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

