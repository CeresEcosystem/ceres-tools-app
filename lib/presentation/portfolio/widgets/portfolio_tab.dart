import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';

class PortfolioTab extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final Function changeTab;

  const PortfolioTab({
    Key? key,
    required this.tabs,
    required this.selectedTab,
    required this.changeTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: Dimensions.DEFAULT_MARGIN_LARGE),
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
          horizontal: Dimensions.DEFAULT_MARGIN,
        ),
        constraints: const BoxConstraints(
          maxWidth: 384,
        ),
        decoration: BoxDecoration(
          color: backgroundColorDark,
          borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
        ),
        child: Row(
          children: tabs.map((tab) {
            final selected = selectedTab == tab;

            return Expanded(
              child: GestureDetector(
                onTap: () => changeTab(tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
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
      ),
    );
  }
}
