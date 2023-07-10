import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prayhelper/pray_helper_app.dart';
import 'controller/webview_controller.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(WebviewMainController());
  await Firebase.initializeApp();
  sleep(Duration(milliseconds: 200));
  runApp(PrayHelperApp());
}

