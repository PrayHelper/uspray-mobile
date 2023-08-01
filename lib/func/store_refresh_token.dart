import 'package:shared_preferences/shared_preferences.dart';

void storeRefreshToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('refreshToken', token);
}

Future<String> getRefreshToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('refreshToken') ?? "unknown";
}