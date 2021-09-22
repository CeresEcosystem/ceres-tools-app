import 'package:ceres_locker_app/core/theme/theme.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/routes/app_pages.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constants/constants.dart';

const kReleaseMode = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Injector.setup();
  
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: kAppName,
        builder: DevicePreview.appBuilder,
        enableLog: false,
        getPages: AppPages.routes,
        initialRoute: Routes.TOKENS,
        themeMode: ThemeMode.dark,
        theme: lightThemeData(),
        darkTheme: darkThemeData(),
      ),
    ),
  );
}
