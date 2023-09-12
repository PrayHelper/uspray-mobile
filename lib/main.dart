import 'package:com.prayhelper.uspray/bloc/link_sharing/invokeDefault.dart';
import 'package:com.prayhelper.uspray/debug/logger.dart';
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
import 'package:flutter/services.dart';

late AndroidNotificationChannel channel;

void main() async {
  Get.put(WebviewMainController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initNotification();
  await initDeepLinks();
  // await InvokeDefault.openManageDefaultAppsSettings();

  // For Kakao
  KakaoSdk.init(
    nativeAppKey: '{YOUR_NATIVE_APP_KEY}',
    // javaScriptAppKey: '{YOUR_JAVASCRIPT_APP_KEY}',
  );
  runApp(PrayHelperApp());
}
