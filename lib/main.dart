import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:com.prayhelper.uspray/pray_helper_app.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'bloc/link_sharing/deeplinking.dart';
import 'bloc/notification/init_notification.dart';
import 'controller/webview_controller.dart';
import 'package:firebase_core/firebase_core.dart';

import 'logger.dart';

late AndroidNotificationChannel channel;

void main() async {
  Get.put(WebviewMainController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  KakaoSdk.init(
      nativeAppKey:"80bf50fbdfeae9aa0acf19984aef9165",
      javaScriptAppKey:"06f05fc4656e611107402eb16961d5ff"
  );

  await initNotification();
  await initDeepLinks();

  runApp(const PrayHelperApp());
}
