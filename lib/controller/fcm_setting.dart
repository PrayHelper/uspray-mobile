
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:com.uspray.prayhelper/controller/local_notification.dart';
import 'package:com.uspray.prayhelper/controller/webview_controller.dart';
import '../func/logger.dart';

void fcmSetting() async{
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