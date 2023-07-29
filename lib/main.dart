import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:com.prayhelper.uspray/pray_helper_app.dart';
import 'package:uni_links/uni_links.dart';
import 'controller/local_notification.dart';
import 'controller/fcm_setting.dart';
import 'controller/webview_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'func/logger.dart';

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
  initDeepLinks();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> initDeepLinks() async {
  // Listen for incoming deep links
  try {
    Uri? initialLink = await getInitialUri();
    handleDeepLink(initialLink);
  } on FormatException {
    // Handle exception if the link is not valid
  }

  // Listen for incoming deep links while the app is running
  uriLinkStream.listen((Uri? uri) {
    handleDeepLink(uri);
  }, onError: (err) {
    // Handle error
  });
}

void handleDeepLink(Uri? uri) {
  if (uri == null) {
    return; // No deep link
  }

  // Check if the deep link matches your custom URL scheme
  if (uri.scheme == 'uspray') {
    logger.d("<<"+uri.toString()+">>");
    // Here, you can extract the path or query parameters from the URI to navigate
    // to the appropriate screen or perform specific tasks within your app.

    // For example, if the URL is "myapp://main", you can navigate to the main screen.
    // If the URL is "myapp://details?id=123", you can open the details screen for the item with id=123.

    // You can use Navigator to navigate to different screens based on the deep link.
  }
}

