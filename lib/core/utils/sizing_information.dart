import 'package:ceres_locker_app/core/enums/device_screen_type.dart';
import 'package:flutter/material.dart';

class SizingInformation {
  final DeviceScreenType deviceScreenType;
  final Size screenSize;
  final Size localWidgetSize;
  final double bottomSafeAreaSize;
  final double topSafeAreaSize;

  SizingInformation({
    required this.deviceScreenType,
    required this.screenSize,
    this.localWidgetSize = const Size(0, 0),
    required this.bottomSafeAreaSize,
    required this.topSafeAreaSize,
  });
}
