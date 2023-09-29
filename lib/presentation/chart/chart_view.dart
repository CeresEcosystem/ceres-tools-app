import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_locker_app/presentation/chart/chart_controller.dart';
import 'package:ceres_locker_app/presentation/chart/widgets/chart.dart';
import 'package:ceres_locker_app/presentation/chart/widgets/swaps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartView extends GetView<ChartController> {
  final PageController _pageController = PageController();

  ChartView({Key? key}) : super(key: key);

  void goToSwapPage() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 350), curve: Curves.ease);
  }

  void goToChartPage() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 350), curve: Curves.ease);
  }

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
          endDrawer: SideMenu(),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: SafeArea(
            top: false,
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Chart(goToSwapPage: goToSwapPage),
                Swaps(
                  sizingInformation: sizingInformation,
                  goToChartPage: goToChartPage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
