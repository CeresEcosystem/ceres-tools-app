import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/presentation/burning/burning_controller.dart';
import 'package:ceres_tools_app/presentation/burning/widgets/burns_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BurningView extends GetView<BurningController> {
  const BurningView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Image.asset(
              'lib/core/assets/images/ceres_tools_logo.png',
              height: Dimensions.HEADER_LOGO,
            ),
          ),
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: BurnsList(
            sizingInformation: sizingInformation,
          ),
        );
      },
    );
  }
}
