import 'dart:io';

import 'package:ceres_locker_app/core/services/global_service.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/theme/theme.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/routes/app_pages.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/constants/constants.dart';

const kReleaseMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Injector.setup();

  await Get.putAsync(() => GlobalService().init());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: backgroundColorDark,
  ));

  OneSignal.shared.setAppId(kPushNotificationID);

  OneSignal.shared.promptUserForPushNotificationPermission();

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
        defaultTransition: Platform.isAndroid ? Transition.noTransition : Transition.native,
      ),
    ),
  );
}
