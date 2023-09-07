import 'dart:io';

import 'package:com.prayhelper.uspray/debug/logger.dart';
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
      logger.d('Error: $e');
    } catch (e){
      logger.d('Error: $e');
    }
  }
}
