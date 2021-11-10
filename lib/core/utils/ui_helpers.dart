// ignore_for_file: constant_identifier_names

import 'package:ceres_locker_app/core/enums/device_screen_type.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:flutter/material.dart';

class UIHelper {
  static const double _VerticalSpaceExtraSmall = 5.0;
  static const double _VerticalSpaceSmall = 10.0;
  static const double _VerticalSpaceSmallMedium = 15.0;
  static const double _VerticalSpaceMedium = 20.0;
  static const double _VerticalSpaceMediumLarge = 30.0;
  static const double _VerticalSpaceBig = 40.0;
  static const double _VerticalSpaceLarge = 60.0;

  static const double _HorizontalSpaceExtraSmall = 5.0;
  static const double _HorizontalSpaceSmall = 10.0;
  static const double _HorizontalSpaceMedium = 20.0;
  static const double HorizontalSpaceLarge = 60.0;

  static Widget verticalSpaceExtraSmall() {
    return verticalSpace(_VerticalSpaceExtraSmall);
  }

  static Widget verticalSpaceSmall() {
    return verticalSpace(_VerticalSpaceSmall);
  }

  static Widget verticalSpaceSmallMedium() {
    return verticalSpace(_VerticalSpaceSmallMedium);
  }

  static Widget verticalSpaceMedium() {
    return verticalSpace(_VerticalSpaceMedium);
  }

  static Widget verticalSpaceMediumLarge() {
    return verticalSpace(_VerticalSpaceMediumLarge);
  }

  static Widget verticalSpaceBig() {
    return verticalSpace(_VerticalSpaceBig);
  }

  static Widget verticalSpaceLarge() {
    return verticalSpace(_VerticalSpaceLarge);
  }

  static Widget verticalSpace(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget horizontalSpaceExtraSmall() {
    return horizontalSpace(_HorizontalSpaceExtraSmall);
  }

  static Widget horizontalSpaceSmall() {
    return horizontalSpace(_HorizontalSpaceSmall);
  }

  static Widget horizontalSpaceMedium() {
    return horizontalSpace(_HorizontalSpaceMedium);
  }

  static Widget horizontalSpaceLarge() {
    return horizontalSpace(HorizontalSpaceLarge);
  }

  static Widget horizontalSpace(double width) {
    return SizedBox(
      width: width,
    );
  }

  static double pagePadding(SizingInformation sizingInformation) {
    return sizingInformation.deviceScreenType == DeviceScreenType.Desktop
        ? Dimensions.DEFAULT_MARGIN_LARGE * 4
        : sizingInformation.deviceScreenType == DeviceScreenType.Tablet
            ? Dimensions.DEFAULT_MARGIN_LARGE * 2
            : Dimensions.DEFAULT_MARGIN;
  }
}
