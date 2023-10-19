import 'package:ceres_locker_app/core/utils/platform.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformation sizingInformation) builder;

  const Responsive({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomSafeAreaSize = MediaQuery.of(context).padding.bottom;
    final topSafeAreaSize = MediaQuery.of(context).padding.top;

    return LayoutBuilder(
      builder: (context, constraints) {
        final sizingInformation = SizingInformation(
          deviceScreenType: getDeviceType(mediaQuery),
          screenSize: mediaQuery.size,
          bottomSafeAreaSize: bottomSafeAreaSize,
          topSafeAreaSize: topSafeAreaSize,
          localWidgetSize: Size(constraints.maxWidth, constraints.maxHeight),
        );
        return builder(context, sizingInformation);
      },
    );
  }
}
