
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:com.prayhelper.uspray/controller/webview_controller.dart';

import '../../debug/logger.dart';
import 'local_notification_setting.dart';

void fcmSetting() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //사용할 함수 명시
  void _requestIosPermissions() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
  void _requestAosPermissions() async{
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  //알림 권한관리
  if (Platform.isIOS) {
    _requestIosPermissions();
  } else if (Platform.isAndroid) {
    _requestAosPermissions();
  }


  //앱단위가 아니라 main에서 정의하는 메시지 핸들링
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    //여기는 사실 local notification의 영역임
    if (notification != null) {
      logger.d("로컬변환 영역");
      displayLocalNotification(flutterLocalNotificationsPlugin, notification);
    }

  });

  // Listen to the onMessageOpenedApp stream
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    WebviewMainController.to.loadUrl("https://www.naver.com/");
    //TODO REAL
    // final url = message.data['url'];
    // if (url != null) {}
  });

}




