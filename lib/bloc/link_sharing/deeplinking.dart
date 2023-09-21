import 'package:com.prayhelper.uspray/controller/webview_controller.dart';
import 'package:uni_links/uni_links.dart';

Future<void> initDeepLinks() async {
  // Listen for incoming deep links
  try {
    Uri? initialLink = await getInitialUri();
    handleDeepLink(initialLink);
  } on FormatException {
    // Handle exception if the link is not valid
  }

  // Listen for incoming deep links while the app is running
  uriLinkStream.listen((Uri? uri) {
    handleDeepLink(uri);
  }, onError: (err) {
    // Handle error
  });
}

void handleDeepLink(Uri? uri) {
  //핸들링 코드정의
  if (uri != null) {
    //TODO Can handling specific path
      WebviewMainController.to.loadUrl(uri.toString());

  }
}
