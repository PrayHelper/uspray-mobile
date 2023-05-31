import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/images/splash-screen.png",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,),
    );
  }
}

class SplashDelay{
  static Future<String> waiting() async{
    await Future.delayed(Duration(milliseconds: 1000));
    return "done";
  }
}


