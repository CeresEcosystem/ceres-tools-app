import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Container(
          height: sizingInformation.topSafeAreaSize,
          color: backgroundColorDark,
        );
      },
    );
  }
}
