import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';

class TokenTab extends StatelessWidget {
  final List<String> tabs;
  final String selectedToken;
  final Function changeToken;

  const TokenTab({
    Key? key,
    required this.tabs,
    required this.selectedToken,
    required this.changeToken,
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
            final selected = selectedToken == tab;

            return Expanded(
              child: GestureDetector(
                onTap: () => changeToken(tab),
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
                          ? tokenTabTextStyle()
                          : tokenTabTextStyle().copyWith(
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
