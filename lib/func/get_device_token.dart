import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getDeviceToken() async {
  String? receivedId;
  var deviceIdentifier = 'unknown';
  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    var androidInfo = await deviceInfo.androidInfo;
    if((receivedId = androidInfo.id) != null){
      deviceIdentifier = receivedId!;
    }

  } else if (Platform.isIOS) {
    var iosInfo = await deviceInfo.iosInfo;
    if((receivedId=iosInfo.identifierForVendor) != null){
      deviceIdentifier = receivedId!;
    }

  }

  return deviceIdentifier;
}

Future<String?> getAuthToken() async{
  final fcmToken = await FirebaseMessaging.instance.getToken();

  return fcmToken;
}