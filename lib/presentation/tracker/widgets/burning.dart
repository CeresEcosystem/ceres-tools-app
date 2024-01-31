import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/presentation/tracker/tracker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Burning extends StatelessWidget {
  final SizingInformation sizingInformation;

  const Burning({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TrackerController controller = Get.find<TrackerController>();

    return ItemContainer(
      sizingInformation: sizingInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttons(
            controller.filterTimes,
            sizingInformation,
            (filter) => controller.setFilterBurning(filter),
            controller.selectedFilterBurning,
          ),
          UIHelper.verticalSpaceMediumLarge(),
          Text(
            '${controller.selectedToken} gross burn',
            style: trackerBlockLabelTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceExtraSmall(),
          RichText(
            text: TextSpan(
              text: formatToCurrency(controller.burnData?['gross']),
              style: trackerBlockPriceStyle(sizingInformation),
              children: <TextSpan>[
                TextSpan(
                  text: ' ${controller.selectedToken}',
                  style: trackerBlockPriceLabelStyle(sizingInformation),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpaceMediumLarge(),
          Text(
            '${controller.selectedToken} net burn',
            style: trackerBlockLabelTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceExtraSmall(),
          RichText(
            text: TextSpan(
              text: formatToCurrency(controller.burnData?['net']),
              style: trackerBlockPriceStyle(sizingInformation).copyWith(
                fontSize: subtitle1,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' ${controller.selectedToken}',
                  style:
                      trackerBlockPriceLabelStyle(sizingInformation).copyWith(
                    fontSize: subtitle1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttons(
      Map<String, String> filterTimes,
      SizingInformation sizingInformation,
      Function onPress,
      String selectedFilter,
      {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    double rightPadding = mainAxisAlignment == MainAxisAlignment.start
        ? Dimensions.DEFAULT_MARGIN_SMALL
        : 0;
    double leftPadding = mainAxisAlignment == MainAxisAlignment.end
        ? Dimensions.DEFAULT_MARGIN_SMALL
        : 0;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: filterTimes.keys.map((filter) {
        return GestureDetector(
          onTap: () => onPress(filter),
          child: Padding(
            padding: EdgeInsets.only(right: rightPadding, left: leftPadding),
            child: Text(
              checkEmptyString(filterTimes[filter]),
              style: buttonFilterStyle(sizingInformation).copyWith(
                color: selectedFilter == filter
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontWeight: selectedFilter == filter
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
