import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:com.prayhelper.uspray/controller/webview_controller.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> notificationSetting() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('notification_icon');

  DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
    );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (payload) async {
      //TODO loadUrl(payload.input!)
      WebviewMainController.to.loadUrl("https://www.naver.com/");
    }
  );
}

Future<void> displayLocalNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteNotification notification) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //TODO 아직 채널을 정하진 않았음
  AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );
  const DarwinNotificationDetails darwinPlatformChannelSpecifics = DarwinNotificationDetails(badgeNumber: 1);

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics, iOS: darwinPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}