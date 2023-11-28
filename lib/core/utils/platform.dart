import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:flutter/material.dart';

DeviceScreenType getDeviceType([MediaQueryData? mediaQuery, double? width]) {
  double deviceWidth = width ?? mediaQuery!.size.width;

  if (deviceWidth >= 1200) {
    return DeviceScreenType.Desktop;
  }

  if (deviceWidth >= 768) {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}
