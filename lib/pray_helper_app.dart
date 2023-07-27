import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.uspray.prayhelper/func/logger.dart';
import 'package:com.uspray.prayhelper/screen/web_view_screen.dart';
import 'package:com.uspray.prayhelper/screen/splash_screen.dart';
import 'package:uni_links/uni_links.dart';
import 'controller/webview_controller.dart';
import 'func/get_device_token.dart';

bool _initialUriIsHandled = false;

class PrayHelperApp extends StatefulWidget {
  PrayHelperApp({super.key});

  @override
  State<PrayHelperApp> createState() => _PrayHelperAppState();
}

class _PrayHelperAppState extends State<PrayHelperApp> {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  StreamSubscription? _sub;
  // 앱 정보 저장
  @override
  Widget build(BuildContext context) {
    final controller = WebviewMainController.to
        .getController();

    return FutureBuilder<List<String>?>(

      future: Future.wait(
        [
          SplashDelay.waiting(),
          getFcmToken()
          //Fetching WebPage
        ],
      ),
      builder: (context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.hasData) {

          logger.d("<<"+snapshot.data![1]+">>");

          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                //테마설정
                primarySwatch: Colors.blue,
              ),
              home: SafeArea(
                child: WebViewScreen(controller: controller),)
          );
        } else {
          return const SplashScreen();
        }
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          logger.d('no initial uri');
        } else {
          WebviewMainController.to.loadUrl(uri.toString());
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        logger.d('failed to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        logger.d('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

}