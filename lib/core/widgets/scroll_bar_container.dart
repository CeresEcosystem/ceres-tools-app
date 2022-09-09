import 'package:ceres_locker_app/core/enums/device_screen_type.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:flutter/material.dart';

class ScrollBarContainer extends StatelessWidget {
  final ScrollController? controller;
  final bool isAlwaysShown;
  final Widget child;
  final SizingInformation sizingInformation;

  const ScrollBarContainer({
    Key? key,
    this.controller,
    this.isAlwaysShown = false,
    required this.child,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile) {
      return child;
    }

    return Scrollbar(
      controller: controller,
      thumbVisibility: isAlwaysShown,
      child: child,
    );
  }
}
