
import 'dart:io';
import 'package:share_plus/share_plus.dart';

Future<void> shareLinkForAOS(String url) async{
  if (Platform.isAndroid) {
    Uri uri = Uri.parse(url);
    await Share.shareUri(uri);
  }
}