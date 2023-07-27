import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:com.uspray.prayhelper/func/get_device_token.dart';

class LoginApi{
  Future<void> sendDeviceToken(String uuid) async {
    String deviceToken = await getDeviceToken();

    final response = await http.post(
      //TODO: BACKEND dev restAPI 주소
      Uri.parse('https://api/dev/uspray.kr'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uuid': uuid,
        'deviceToken': deviceToken
      }),
    );
    if (response.statusCode == 200) {
      print("resultOK");
    } else {
      print('Request failed: ${response.statusCode}.');
    }
  }

}


