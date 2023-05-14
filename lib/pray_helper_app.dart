import 'package:flutter/material.dart';
import 'package:prayhelper/screen/MainScreen.dart';
import 'package:prayhelper/screen/SplashScreen.dart';

class PrayHelperApp extends StatelessWidget {
  const PrayHelperApp({super.key});

  // 앱 정보 저장
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
      future: Future.wait(
          [
            SplashDelay.waiting(),
            //Fetching WebPage
          ],
      ),
      builder: (context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              //테마설정
              primarySwatch: Colors.blue,
            ),
            home: const MainScreen(title: 'Flutter Demo Home Page'),
          );
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}