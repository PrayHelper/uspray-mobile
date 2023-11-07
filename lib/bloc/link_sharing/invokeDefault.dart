import 'dart:io';
import 'package:flutter/services.dart';

class InvokeDefault {
  static const channel =
      MethodChannel("com.prayhelper.uspray/invokeDefault");

  static Future<void> openManageDefaultAppsSettings() async {
    try {
      if(Platform.isAndroid){
        await channel.invokeMethod('openManageDefaultAppsSettings');
      }
    } on PlatformException catch (e) {
    } catch (e){
    }
  }
}
