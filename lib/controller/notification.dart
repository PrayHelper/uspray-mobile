import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prayhelper/func/logger.dart';

final notifications = FlutterLocalNotificationsPlugin();


// 앱로드시 기본설정
initNotification() async {

  //안드로이드용 아이콘파일 이름
  var androidSetting = const AndroidInitializationSettings('notification_icon');

  //ios에서 앱 로드시 유저에게 권한요청하려면
  var iosSetting = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting
  );
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    //onSelectNotification: 함수명추가
  );
}

//2. 이 함수 원하는 곳에서 실행하면 알림 뜸
showNotification() async {

  logger.d("IS?");

  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      '테스트용 타이틀',
      '테스트용 메시지',
      NotificationDetails(android: androidDetails, iOS: iosDetails)
  );

  logger.d("IS DONE?");
}