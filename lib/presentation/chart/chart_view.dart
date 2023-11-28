import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_tools_app/presentation/chart/chart_controller.dart';
import 'package:ceres_tools_app/presentation/chart/widgets/chart.dart';
import 'package:ceres_tools_app/presentation/chart/widgets/swaps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartView extends GetView<ChartController> {
  const ChartView({Key? key}) : super(key: key);

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
          endDrawer: Get.arguments != null && Get.arguments['replace'] == false
              ? null
              : SideMenu(),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: SafeArea(
            top: false,
            child: PageView(
              controller: controller.pageController,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const Chart(),
                Swaps(
                  sizingInformation: sizingInformation,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
