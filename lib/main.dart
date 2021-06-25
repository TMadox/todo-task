import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:todo/Pages/Todopage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firedart/firedart.dart';

Future<void> main() async {
  if (!Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  } else {
    print("test");
  }
  runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>
          ProviderScope(child: GetMaterialApp(home: TodoPage()))));
}
