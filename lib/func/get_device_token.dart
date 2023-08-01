import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getFcmToken() async{
  final fcmToken = await FirebaseMessaging.instance.getToken();

  if(fcmToken == null){
    return "unknown";
  }else{
    return fcmToken!;
  }
}