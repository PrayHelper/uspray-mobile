import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayhelper/funct/get_device_token.dart';
import 'package:prayhelper/pray_helper_app.dart';
import 'controller/webview_controller.dart';
import 'funct/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(WebviewMainController());
  runApp(PrayHelperApp());
}

