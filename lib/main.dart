import 'dart:io';

import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/theme/theme.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/routes/app_pages.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'core/constants/constants.dart';

const kReleaseMode = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(1200.0, 800.0);
      win.minSize = initialSize;
      win.alignment = Alignment.center;
      win.title = kAppTitle;
      win.show();
    });
  }

  Injector.setup();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: backgroundColorDark,
  ));

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: kAppName,
        builder: DevicePreview.appBuilder,
        enableLog: false,
        getPages: AppPages.routes,
        initialRoute: Routes.MAIN,
        themeMode: ThemeMode.dark,
        theme: lightThemeData(),
        darkTheme: darkThemeData(),
      ),
    ),
  );
}
