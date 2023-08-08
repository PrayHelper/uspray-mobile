
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'fcm_setting.dart';
import 'local_notification_setting.dart';

Future<void> initNotification() async {
  await notificationSetting();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  fcmSetting();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}