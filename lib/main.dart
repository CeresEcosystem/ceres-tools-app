import 'dart:io';

import 'package:ceres_tools_app/core/services/global_service.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/theme/theme.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/routes/app_pages.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Injector.setup();

  OneSignal.initialize(kPushNotificationID);

  OneSignal.Notifications.canRequest().then((canRequest) {
    if (canRequest) {
      OneSignal.Notifications.requestPermission(true);
    }
  });

  OneSignal.Debug.setLogLevel(OSLogLevel.error);

  await Get.putAsync(() => GlobalService().init());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: chartBackground,
  ));

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: kAppName,
          enableLog: false,
          getPages: AppPages.routes,
          initialRoute: Routes.TOKENS,
          themeMode: ThemeMode.dark,
          theme: lightThemeData(),
          darkTheme: darkThemeData(),
          defaultTransition:
              Platform.isAndroid ? Transition.noTransition : Transition.native,
          transitionDuration: Platform.isAndroid
              ? Duration.zero
              : const Duration(milliseconds: 300),
        );
      },
    ),
  );
}
