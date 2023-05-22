import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prayhelper/func/get_device_token.dart';

class LoginApi{
  Future<void> sendDeviceToken(String uuid) async {
    String deviceToken = await getDeviceToken();

    final response = await http.post(
      //TODO: BACKEND restAPI 주소
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uuid': uuid,
        'deviceToken': deviceToken
      }),
    );
    if (response.statusCode == 200) {
      print("device Token is passed");
    } else {
      print('Request failed: ${response.statusCode}.');
    }
  }

}


