import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/presentation/portfolio/portfolio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioTab extends StatelessWidget {
  final PortfolioController controller = Get.find();
  final List<String> tabs;
  final String selectedTab;
  final Function changeTab;

  PortfolioTab({
    Key? key,
    required this.tabs,
    required this.selectedTab,
    required this.changeTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
        horizontal: Dimensions.DEFAULT_MARGIN_SMALL,
      ),
      color: backgroundColorDark,
      child: Row(
        children: tabs.map((tab) {
          final selected = selectedTab == tab;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (controller.loadingStatus == LoadingStatus.READY) {
                  changeTab(tab);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withOpacity(.1)
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: selected
                        ? portfolioTabTextStyle()
                        : portfolioTabTextStyle().copyWith(
                            color: Colors.white.withOpacity(.5),
                          ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
