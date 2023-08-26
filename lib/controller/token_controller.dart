import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getFcmToken() async{
  final fcmToken = await FirebaseMessaging.instance.getToken();

  if(fcmToken == null){
    return "unknown";
  }else{
    return fcmToken!;
  }
}

Future<void> storeRefreshToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('refreshToken', token);
}

Future<String> getRefreshToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('refreshToken') ?? "";
}