import 'dart:async';
import 'package:flutter/material.dart';
import 'package:com.prayhelper.uspray/screen/webview_screen.dart';
import 'package:com.prayhelper.uspray/screen/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'controller/token_controller.dart';
import 'controller/webview_controller.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

bool _initialUriIsHandled = false;

class PrayHelperApp extends StatefulWidget {
  const PrayHelperApp({super.key});

  @override
  State<PrayHelperApp> createState() => _PrayHelperAppState();
}

class _PrayHelperAppState extends State<PrayHelperApp> {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  StreamSubscription? _sub;

  @override
  Widget build(BuildContext context) {
    final controller = WebviewMainController.to.getController();
    WebviewMainController.to.setPlatformSpecifics(controller);
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }

    return FutureBuilder<List<String>?>(
      future: Future.wait([SplashDelay.waiting()]),
      builder: (context, AsyncSnapshot<List<String>?> snapshot) {
        return (snapshot.hasData)
            ? MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  //테마설정
                  primarySwatch: Colors.blue,
                ),
                home: SafeArea(
                  child: WebViewScreen(controller: controller),
                ))
            : const SplashScreen();
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
    super.dispose();
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;

      try {
        final uri = await getInitialUri();
        if (uri == null) {
        } else {
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
      } on FormatException catch (err) {
        if (!mounted) return;
        setState(() => _err = err);
      }
    }
  }


}
