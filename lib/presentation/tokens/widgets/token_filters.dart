import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/empty_widget.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/core/widgets/search_text_field.dart';
import 'package:ceres_tools_app/presentation/tokens/tokens_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TokenFilters extends StatelessWidget {
  final SizingInformation sizingInformation;
  final Function setShowTokenPriceCalculator;

  const TokenFilters({
    Key? key,
    required this.sizingInformation,
    required this.setShowTokenPriceCalculator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TokensController controller = Get.find<TokensController>();

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.pagePadding(sizingInformation)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SearchTextField(
                  onChanged: (text) => controller.onTyping(text),
                  hint: kSearchTextFieldHint,
                ),
              ),
              UIHelper.horizontalSpaceSmall(),
              GestureDetector(
                onTap: () => setShowTokenPriceCalculator(),
                child: Container(
                  padding: const EdgeInsets.all(
                      Dimensions.DEFAULT_MARGIN_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    color: backgroundPink,
                    borderRadius:
                        BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                  ),
                  child: const Icon(Icons.calculate),
                ),
              )
            ],
          ),
          UIHelper.verticalSpaceSmallMedium(),
          SizedBox(
            height: 35,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final filter = controller.filters[index];
                final isActive = filter == controller.selectedFilter;

                return GestureDetector(
                  onTap: () => controller.setFilter(filter),
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: Dimensions.PAIRS_IMAGE_SIZE,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(Dimensions.DEFAULT_MARGIN),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL / 2,
                      horizontal: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                    ),
                    child: Opacity(
                      opacity: isActive ? 1 : 0.5,
                      child: Center(
                        child: Row(
                          children: [
                            filterIcon(filter),
                            if (filter != 'All')
                              (UIHelper.horizontalSpaceExtraSmall()),
                            Text(
                              filter,
                              style: allButtonTextStyle(sizingInformation),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => UIHelper.horizontalSpaceExtraSmall(),
              itemCount: controller.filters.length,
            ),
          ),
          UIHelper.verticalSpaceSmall(),
        ],
      ),
    );
  }

  Widget filterIcon(String filter) {
    if (filter == 'Favorites') {
      return const Icon(Icons.star);
    } else if (filter == 'Synthetics') {
      return const RoundImage(
        image: '${kImageStorage}XST.svg',
        size: Dimensions.SOCIAL_ICONS_SIZE,
      );
    } else {
      return const EmptyWidget();
    }
  }
}
